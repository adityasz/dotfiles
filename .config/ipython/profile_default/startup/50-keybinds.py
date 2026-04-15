"""Generated-by: Claude:claude-sonnet-4.6"""

from prompt_toolkit.filters import vi_insert_mode, vi_navigation_mode

ip = get_ipython()

if ip and hasattr(ip, 'pt_app') and ip.pt_app:
    kb = ip.pt_app.key_bindings

    @kb.add('c-k', filter=vi_insert_mode | vi_navigation_mode)
    def clear_screen(event):
        event.app.renderer.clear()
