import shlex

from subprocess import CalledProcessError, check_output, run, PIPE
from denite.base.kind import Base

class Kind(Base):

    def __init__(self, vim):
        super().__init__(vim)

        self.name = 'music'
        self.default_action = 'play'

    def action_play(self, context) -> None:
        target = context['targets'][0]
        plname = target['word'].replace("'", "'\"'\"'")
        cmd_s = 'osascript -e \'tell app "Music" to set shuffle enabled to false\''
        cmd = 'osascript -e \'tell app "Music" to play playlist "' + plname + '"\' &'
        try:
            run(cmd_s, shell=True, text=True)
            run(cmd, shell=True, text=True)
            self.vim.command('redraw! | echo \'Play playlist "' + plname + '"\'')
        except CalledProcessError as e:
            err_msg = e.stderr.splitlines()
            self.error_message(context, err_msg)

    def action_play_s(self, context) -> None:
        target = context['targets'][0]
        plname = target['word'].replace("'", "'\"'\"'")
        cmd_s = 'osascript -e \'tell app "Music" to set shuffle enabled to true\''
        cmd = 'osascript -e \'tell app "Music" to play playlist "' + plname + '"\' &'
        try:
            run(cmd_s, shell=True, text=True)
            run(cmd, shell=True, text=True)
            self.vim.command('redraw! | echo \'Play playlist "' + plname + '" by shuffle\'')
        except CalledProcessError as e:
            err_msg = e.stderr.splitlines()
            self.error_message(context, err_msg)

    def action_enter_track(self, context) -> None:
        self.vim.command('Denite -no-empty -buffer-name=tracks tracks:' + context['targets'][0]['word'])
        #self.sources_refine(context)

#    def sources_refine(self, context) -> None:
#        context['sources_queue'].append([{'name': 'tracks', 'args': context['targets'][0]['word']},])
