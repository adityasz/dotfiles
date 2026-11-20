"""Assisted-by: Claude:claude-sonnet-{4.6,5.5}"""

import re
from dataclasses import dataclass

from kitty.fast_data_types import Screen, get_boss, get_options, wcswidth
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
    bg: int


@dataclass(frozen=True, slots=True)
class Theme:
    bg: int
    sep_fg: int
    active: TabColors
    inactive: TabColors


SCROLL = Theme(
    0x6A9FB5,
    0xE0ECF0,
    TabColors(0xE8F4FF, 0xFFFFFF, 0x8FF0A4, 0x35596A),
    TabColors(0xC0D4DC, 0xD8E4EC, 0xA8E6CF, 0x6A9FB5),
)

SGR_RE = re.compile(r"\x1b\[[^m]*m")
CAP_L = "\ue0b6"
CAP_R = "\ue0b4"
CAP_W = 1


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
    tab_colors: TabColors,
    max_length: int,
) -> None:
    """Draw: [bell/activity] index: [progress] [exe] [title]"""
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

        # truncate exe with ellipsis
        if exe_w + sep_w + title_w > remaining and exe_w > remaining:
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
    if limit := get_options().tab_title_max_length:
        max_tab_length = min(max_tab_length, limit)
    theme = (
        SCROLL
        if get_boss().mappings.current_keyboard_mode_name == "scroll"
        else Theme(
            int(draw_data.default_bg),
            0xAAAAAA,
            TabColors(
                0x3584E4,
                int(draw_data.active_fg),
                int(draw_data.active_fg),
                int(draw_data.active_bg),
            ),
            TabColors(
                0x808080,
                int(draw_data.inactive_fg),
                int(draw_data.inactive_fg),
                int(draw_data.inactive_bg),
            ),
        )
    )
    colors = theme.active if tab.is_active else theme.inactive
    bg = as_rgb(colors.bg)
    theme_bg = as_rgb(theme.bg)
    next_active = extra_data.next_tab is not None and extra_data.next_tab.is_active

    # The active pill absorbs one separator width on each side. An inactive tab
    # at an end reserves that width outside, so the bar width stays constant.
    pad = wcswidth(draw_data.sep)
    inner = pad if tab.is_active else 0
    edge_l = pad if not tab.is_active and extra_data.prev_tab is None else 0
    edge_r = pad if not tab.is_active and is_last else 0

    lead = draw_data.leading_spaces + inner
    trail = min(max_tab_length - 1, draw_data.trailing_spaces) + inner
    title_budget = max_tab_length - lead - trail - 2 * CAP_W - edge_l - edge_r

    screen.color_profile.default_bg = color_from_int(theme.bg)
    screen.cursor.fg = bg
    screen.cursor.bg = theme_bg
    screen.draw(" " * edge_l + CAP_L)
    screen.cursor.bg = bg
    screen.draw(" " * lead)

    draw_title(draw_data, screen, tab, index, colors, title_budget)

    max_tab_length -= trail + CAP_W + edge_r
    extra = screen.cursor.x - before - max_tab_length
    if extra > 0:
        screen.cursor.x -= extra + 1
        screen.draw("…")
    screen.draw(" " * trail)
    screen.cursor.fg = bg
    screen.cursor.bg = theme_bg
    screen.draw(CAP_R)
    end = screen.cursor.x
    screen.draw(" " * edge_r)

    if not (is_last or tab.is_active or next_active):
        screen.cursor.fg = as_rgb(theme.sep_fg)
        screen.cursor.bg = theme_bg
        screen.draw(draw_data.sep)

    screen.cursor.fg = 0
    screen.cursor.bg = 0

    return end
