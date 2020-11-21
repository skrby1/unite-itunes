import os
import shlex
import unicodedata

from subprocess import CalledProcessError, check_output, run, PIPE
from denite.base.source import Base

def geteaw_count(text):
    count = 0
    for c in text:
        if unicodedata.east_asian_width(c) in 'FWA':
            count += 2
        else:
            count += 1
    return count

class Source(Base):

    def __init__(self, vim):
        super().__init__(vim)

        self.name = 'music'
        self.kind = 'music'
        self.sorters = ['sorter/playlist']

    def on_init(self, context):
        filepath = shlex.quote(os.path.normpath(os.path.join(os.path.dirname(__file__),
            '../lib/ps_check.applescript')))
        try:
            run('osascript ' + filepath, shell=True, text=True)
        except CalledProcessError as e:
            err_msg = e.stderr.splitlines()
            self.error_message(context, err_msg)

    def gather_candidates(self, context):
        if not context['args']: #go music
            filepath = shlex.quote(os.path.normpath(os.path.join(os.path.dirname(__file__),
                '../lib/music1.applescript')))
            try:
                p = run('osascript ' + filepath + ' | perl -pe \'s/\r/\n/g\'',
                        shell=True, stdout=PIPE, stderr=PIPE, text=True)
                plists = p.stdout.splitlines()
            except CalledProcessError as e:
                err_msg = e.stderr.splitlines()
                self.error_message(context, err_msg)
                return []

            candidates = []
            for entry in plists:
                value = entry.split('\t')
                candidate = {}
                candidate['word'] = value[0]
                moji = geteaw_count(value[0])
                candidate['abbr'] = ('{}'
                        + ' ' * (self.vim.funcs.winwidth(0) - moji - 11)
                        + ' {:>9} ').format(value[0],value[1])
                candidates.append(candidate)

            return candidates
        else: #go tracks
            act = context['args'][0]
            if act == '!':
                try:
                    run('osascript -e \'tell app "Music" to playpause\' &', shell=True, text=True)
                except CalledProcessError as e:
                    err_msg = e.stderr.splitlines()
                    self.error_message(context, err_msg)
                return []
            elif act == 'a' or act == 'n' or act == 'y' or act == 't' or act == '>' or act == '<':
                tracks_args = 'Denite -no-empty -buffer-name=tracks tracks:' \
                        + ':'.join(list(context['args']))
                self.vim.command(tracks_args)
                return []
            else:
                return []
