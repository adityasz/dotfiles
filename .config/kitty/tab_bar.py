"""Assisted-by: Claude:claude-sonnet-4.6"""

import re
from dataclasses import dataclass

from kitty.fast_data_types import Screen, get_boss, wcswidth
from kitty.rgb import color_from_int
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    TabAccessor,
    TabBarData,
    as_rgb,
    draw_attributed_string,
)


@dataclass(frozen=True, slots=True)
class TabColors:
    index_fg: int
    title_fg: int
    exe_fg: int


@dataclass(frozen=True, slots=True)
class Theme:
    bg: int
    sep_fg: int
    active: TabColors
    inactive: TabColors


NORMAL = Theme(
    bg=0xF7F8FA,
    sep_fg=0xCCCCCC,
    active=TabColors(0x3584E4, 0x000000, 0x26A269),
    inactive=TabColors(0x808080, 0x888888, 0x8FF0A4),
)

SCROLL = Theme(
    bg=0x6A9FB5,
    sep_fg=0xE0ECF0,
    active=TabColors(0xE8F4FF, 0xFFFFFF, 0x8FF0A4),
    inactive=TabColors(0xC0D4DC, 0xD8E4EC, 0xA8E6CF),
)

SGR_RE = re.compile(r"\x1b\[[^m]*m")


def strip_sgr(s: str) -> str:
    return SGR_RE.sub("", s)


def take_width(s: str, max_w: int, from_end: bool = False) -> str:
    """Longest prefix (or suffix) of s that fits in max_w columns."""
    if max_w <= 0:
        return ""
    chars = list(s)
    if from_end:
        chars = list(reversed(chars))
    result: list[str] = []
    w = 0
    for c in chars:
        cw = wcswidth(c)
        if cw < 0:
            cw = 1  # treat control chars as width-1
        if w + cw > max_w:
            break
        result.append(c)
        w += cw
    if from_end:
        result = list(reversed(result))
    return "".join(result)


def truncate_middle(s: str, max_w: int) -> str:
    if max_w <= 0:
        return ""
    if wcswidth(s) <= max_w:
        return s
    if max_w == 1:
        return "…"
    left_w = (max_w - 1) // 2
    right_w = max_w - 1 - left_w
    return take_width(s, left_w) + "…" + take_width(s, right_w, from_end=True)


def truncate_path(s: str, max_w: int) -> str:
    if max_w <= 0:
        return ""
    return truncate_middle(s.rstrip("/").rsplit("/", 1)[-1], max_w)


def draw_title(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    index: int,
    theme: Theme,
    max_length: int,
) -> None:
    """Draw: [bell/activity] index: [progress] [exe] [title]"""
    tab_colors = theme.active if tab.is_active else theme.inactive
    ta = TabAccessor(tab.tab_id)

    # Fixed-width pieces
    attn = ""
    if tab.needs_attention:
        attn += draw_data.bell_on_tab
    if tab.has_activity_since_last_focus:
        attn += draw_data.tab_activity_symbol
    if attn:
        attn += " "
    attn_w = wcswidth(attn)

    idx = f"{index}:"
    idx_w = wcswidth(idx)

    progress = ""
    if p := ta.last_focused_progress_percent.strip():
        progress = f" {p}"
    prog_w = wcswidth(progress)

    fixed_w = attn_w + idx_w + prog_w

    # Variable pieces
    exe = ta.active_exe
    if exe == "zsh":
        exe = ""
    exe_w = wcswidth(exe)

    title_raw = tab.title or ""
    title = strip_sgr(title_raw)
    title_w = wcswidth(title)

    sep_w = 1 if (exe and title) else 0

    # Truncation
    remaining = max_length - fixed_w

    if exe_w + sep_w + title_w > remaining:
        # truncate title, then drop it if still over
        if title:
            budget = remaining - exe_w - (1 if exe else 0)
            if budget >= 1:
                title = (
                    truncate_path(title, budget)
                    if "/" in title  # a good heuristic to detect paths
                    else truncate_middle(title, budget)
                )
            else:
                title = ""
            title_w = wcswidth(title) if title else 0
            sep_w = 1 if (exe and title) else 0

        if exe_w + sep_w + title_w > remaining:
            # truncate exe with ellipsis
            if exe_w > remaining:
                if remaining >= 2:
                    exe = take_width(exe, remaining - 1) + "…"
                elif remaining == 1:
                    exe = "…"
                else:
                    exe = ""

    # Draw
    screen.cursor.bold = False
    screen.cursor.italic = False

    if attn:
        screen.cursor.fg = as_rgb(0xFF0000)
        screen.draw(attn)

    screen.cursor.fg = as_rgb(tab_colors.index_fg)
    screen.draw(idx)

    if progress:
        screen.cursor.fg = as_rgb(tab_colors.title_fg)
        screen.draw(progress)

    if exe:
        if progress:
            screen.draw(" ")
        screen.cursor.bold = True
        screen.cursor.fg = as_rgb(tab_colors.exe_fg)
        screen.draw(exe)
        screen.cursor.bold = False

    if title:
        screen.cursor.fg = as_rgb(tab_colors.title_fg)
        if sep_w:
            screen.draw(" ")
        if title == strip_sgr(title_raw):  # no truncation happened
            draw_attributed_string(title_raw, screen)
        else:
            screen.draw(title)  # truncated plain text


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_tab_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    theme = (
        SCROLL if get_boss().mappings.current_keyboard_mode_name == "scroll" else NORMAL
    )
    bg = as_rgb(theme.bg)

    screen.cursor.bg = bg
    screen.color_profile.default_bg = color_from_int(theme.bg)

    leading = draw_data.leading_spaces
    trailing = min(max_tab_length - 1, draw_data.trailing_spaces)
    title_budget = max_tab_length - leading - trailing

    if draw_data.leading_spaces:
        screen.draw(" " * draw_data.leading_spaces)

    draw_title(draw_data, screen, tab, index, theme, title_budget)

    trailing_spaces = min(max_tab_length - 1, draw_data.trailing_spaces)
    max_tab_length -= trailing_spaces
    extra = screen.cursor.x - before - max_tab_length
    if extra > 0:
        screen.cursor.x -= extra + 1
        screen.draw("…")
    if trailing_spaces:
        screen.draw(" " * trailing_spaces)
    end = screen.cursor.x

    if not is_last:
        screen.cursor.fg = as_rgb(theme.sep_fg)
        screen.cursor.bg = as_rgb(theme.bg)
        screen.draw(draw_data.sep)

    screen.cursor.fg = 0
    screen.cursor.bg = 0

    return end
