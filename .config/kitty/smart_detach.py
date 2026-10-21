"""Assisted-by: Codex:gpt-6.1-sol-medium

Obviously identifiable and trivially fixable slop was fixed.
"""

from kittens.tui.handler import result_handler
from kitty.boss import Boss


def main(_args: list[str]) -> None: ...


@result_handler(no_ui=True)
def handle_result(
    args: list[str], _answer: None, _target_window_id: int, boss: Boss
) -> None:
    direction = args[1]
    if direction not in ("left", "right"):
        msg = "Expected 'left' or 'right'"
        raise ValueError(msg)

    tm = boss.active_tab_manager
    if tm is None:
        return
    tab = tm.active_tab
    if tab is None:
        return

    neighbor = tm.tab_at_location(direction)
    if neighbor is None:
        return

    if neighbor is tab and tab.num_window_groups == 1:
        return

    current_index = tm.tabs.index(tab)
    neighbor_index = tm.tabs.index(neighbor)
    at_boundary = (
        neighbor_index >= current_index
        if direction == "left"
        else neighbor_index <= current_index
    )
    boss.detach_window(
        f"new-tab-{direction}"
        if at_boundary and tab.num_window_groups > 1
        else f"tab-{direction}"
    )
