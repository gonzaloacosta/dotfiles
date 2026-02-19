"""Tokyo Night colorscheme for ranger.

Designed to match folke/tokyonight.nvim (night variant).
Relies on terminal ANSI colors being mapped to tokyonight palette
(e.g. via Ghostty theme = TokyoNight).
"""

from ranger.gui.color import (
    BRIGHT,
    black,
    blue,
    bold,
    cyan,
    default,
    dim,
    green,
    magenta,
    normal,
    red,
    reverse,
    white,
    yellow,
)
from ranger.gui.colorscheme import ColorScheme


class Scheme(ColorScheme):
    progress_bar_color = blue

    def use(self, context):  # noqa: C901
        fg, bg, attr = default, default, normal

        if context.reset:
            return default, default, normal

        elif context.in_browser:
            if context.selected:
                attr = reverse
            if context.empty or context.error:
                fg = red
            if context.border:
                fg = default
            if context.image or context.video:
                fg = magenta
            if context.audio:
                fg = cyan
            if context.document:
                fg = yellow
            if context.container:
                fg = red | BRIGHT
            if context.directory:
                attr |= bold
                fg = blue
            elif context.executable and not any(
                (context.media, context.fifo, context.socket)
            ):
                fg = green
                attr |= bold
            if context.socket:
                fg = magenta | BRIGHT
                attr |= bold
            if context.fifo or context.device:
                fg = yellow
                if context.device:
                    attr |= bold
            if context.link:
                fg = cyan if context.good else red
            if context.tag_marker and not context.selected:
                attr |= bold
                fg = red
            if not context.selected and (context.cut or context.copied):
                attr |= bold
                fg = black
                attr |= BRIGHT
            if context.main_column:
                if context.selected:
                    attr = bold
                    fg = white
                    bg = blue
                if context.marked:
                    attr |= bold
                    fg = yellow
                    bg = blue
            if context.badinfo:
                if attr & reverse:
                    bg = magenta
                else:
                    fg = magenta

            if context.inactive_pane:
                fg = cyan
                attr |= dim

        elif context.in_titlebar:
            if context.hostname:
                fg = red if context.bad else green
            elif context.directory:
                fg = blue
                attr |= bold
            elif context.tab:
                if context.good:
                    bg = blue
                    fg = black
            elif context.link:
                fg = cyan

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = green
                elif context.bad:
                    fg = red
            if context.marked:
                attr |= bold | reverse
                fg = yellow
            if context.frozen:
                attr |= bold
                fg = cyan
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = red
            if context.loaded:
                bg = self.progress_bar_color
            if context.vcsinfo:
                fg = blue
                attr &= ~bold
            if context.vcscommit:
                fg = yellow
                attr &= ~bold

        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = blue
            if context.selected:
                attr |= reverse
            if context.loaded:
                if context.selected:
                    fg = self.progress_bar_color
                else:
                    bg = self.progress_bar_color

        if context.vcsfile and not context.selected:
            attr &= ~bold
            if context.vcsconflict:
                fg = red
            elif context.vcsuntracked:
                fg = cyan
            elif context.vcschanged:
                fg = yellow
            elif context.vcsunknown:
                fg = red
            elif context.vcsstaged:
                fg = green
            elif context.vcssync:
                fg = green
            elif context.vcsignored:
                fg = default
                attr |= dim

        elif context.vcsremote and not context.selected:
            attr &= ~bold
            if context.vcssync or context.vcsnone:
                fg = green
            elif context.vcsbehind:
                fg = yellow
            elif context.vcsahead:
                fg = cyan
            elif context.vcsdiverged:
                fg = magenta
            elif context.vcsunknown:
                fg = red

        return fg, bg, attr
