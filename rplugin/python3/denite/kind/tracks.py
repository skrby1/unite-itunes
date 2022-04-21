import os
import shlex

from subprocess import CalledProcessError, check_output, run, PIPE
from denite.base.kind import Base

class Kind(Base):

    def __init__(self, vim):
        super().__init__(vim)

        self.name = 'tracks'
        self.default_action = 'play'

    def action_play(self, context) -> None:
        target = context['targets'][0]
        name = target['name'].replace('[s] ', '').replace('[S] ', '').replace('[c] ', '').replace('"', '\\"')
        cmd_s = 'osascript -e \'tell app "Music" to set shuffle enabled to false\''

        if target['plflag']:
            cmd = 'osascript -e \'tell app "Music" to play track id ' + target['id'] + ' of playlist "' + target['plname'] + '"\' &'
            name = name + '" of playlist "' + target['plname']
        else:
            cmd = 'osascript -e \'tell app "Music" to play track id ' + target['id'] + '\' &'

        try:
            run(cmd_s, shell=True, text=True)
            run(cmd, shell=True, text=True)
        except CalledProcessError as e:
            err_msg = e.stderr.splitlines()
            self.error_message(context, err_msg)
        self.vim.command('redraw! | echo \'Play track "\' . "' + name + '" . \'"\'')

    def action_add_next(self, context) -> None:
        target = context['targets'][0]
        name = target['name'].replace('[s] ', '').replace('[S] ', '').replace('[c] ', '').replace('"', '\\"')
        cmd = 'osascript ~/.cache/dein/repos/github.com/skrby1/unite-itunes/rplugin/python3/denite/lib/add_track_to_next.applescript "' + name + '"'
        try:
            run(cmd, shell=True, text=True)
        except CalledProcessError as e:
            err_msg = e.stderr.splitlines()
            self.error_message(context, err_msg)
        self.vim.command('redraw! | echo \'Add next "\' . "' + name + '" . \'"\'')

    def action_add_after(self, context) -> None:
        target = context['targets'][0]
        name = target['name'].replace('[s] ', '').replace('[S] ', '').replace('[c] ', '').replace('"', '\\"')
        cmd = 'osascript ~/.cache/dein/repos/github.com/skrby1/unite-itunes/rplugin/python3/denite/lib/add_track_to_after.applescript "' + name + '"'
        try:
            run(cmd, shell=True, text=True)
        except CalledProcessError as e:
            err_msg = e.stderr.splitlines()
            self.error_message(context, err_msg)
        self.vim.command('redraw! | echo \'Add after "\' . "' + name + '" . \'"\'')

    def action_play_s(self, context) -> None:
        filepath = shlex.quote(os.path.normpath(os.path.join(os.path.dirname(__file__),
            '../lib/music3.applescript')))
        target = context['targets'][0]
        album = target['album'].replace('"', '\\"')
        artist = target['artist']
        tid = target['id']
        cmd_s = 'osascript -e \'tell app "Music" to set shuffle enabled to true\''
        cmd = 'osascript ' + filepath + " \"" + album + "\" \"" + artist + "\" '" + tid + "'"
        self.vim.command('redraw! | echo \'Now Loading...\'')
        try:
            run(cmd_s, shell=True, text=True)
            run(cmd, shell=True, text=True)
        except CalledProcessError as e:
            err_msg = e.stderr.splitlines()
            self.error_message(context, err_msg)
        self.vim.command('redraw! | echo \'Play album "\' . "' + album + '" . \'" by shuffle\'')

    def action_play_a(self, context) -> None:
        filepath = shlex.quote(os.path.normpath(os.path.join(os.path.dirname(__file__),
            '../lib/music3.applescript')))
        target = context['targets'][0]
        album = target['album'].replace('"', '\\"')
        artist = target['artist']
        tid = target['id']
        cmd_s = 'osascript -e \'tell app "Music" to set shuffle enabled to false\''
        cmd = 'osascript ' + filepath + " \"" + album + "\" \"" + artist + "\" '" + tid + "'"
        self.vim.command('redraw! | echo \'Now Loading...\'')
        try:
            run(cmd_s, shell=True, text=True)
            run(cmd, shell=True, text=True)
        except CalledProcessError as e:
            err_msg = e.stderr.splitlines()
            self.error_message(context, err_msg)
        self.vim.command('redraw! | echo \'Play album "\' . "'  + album + '" . \'"\'')

    def action_back(self, context) -> None:
        if context['targets'][0]['plflag']:
            self.vim.command('Denite -no-empty -buffer-name=music music')
