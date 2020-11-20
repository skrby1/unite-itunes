import os
import shlex
import unicodedata

from subprocess import CalledProcessError, check_output, run, PIPE
from denite.base.source import Base

def geteaw_count(text):
    count = 0
    for c in text:
        if unicodedata.east_asian_width(c) in 'FWA':
            count += 1
    return count

class Source(Base):

    def __init__(self, vim):
        super().__init__(vim)

        self.name = 'tracks'
        self.kind = 'tracks'
        self.sorters = ['sorter/tracks']
        self.is_public_context = True

    def gather_candidates(self, context):
        filepath = shlex.quote(os.path.normpath(os.path.join(os.path.dirname(__file__),
            '../lib/music2.applescript')))
        if len(context['args']) > 1:
            argv = '|'.join(list(context['args']))
            plflag = 0
        else:
            argv = str(context['args'][0])
            plflag = 1

        try:
            p = run('osascript ' + filepath + ' \'' + argv
                    + '\' | perl -pe \'s/\r/\n/g\'',
                    shell=True, stdout=PIPE, stderr=PIPE, text=True)
            plists = p.stdout.splitlines()
        except CalledProcessError as e:
            err_msg = e.stderr.splitlines()
            self.error_message(context, err_msg)
            return []

        winw = int(self.vim.funcs.winwidth(0) / 3)
        candidates = []
        for entry in plists:
            value = entry.split('\t')
            if value[0]:
                candidate = {}
                candidate['word'] = value[0]
                candidate['album'] = value[1]
                candidate['artist'] = value[2]
                candidate['tkno'] = value[3]
                candidate['id'] = value[4]
                candidate['plflag'] = plflag
                candidate['plname'] = value[5]
                moji1 = value[0][:int(winw * 1.27) - int(geteaw_count(value[0]))]
                moji2 = value[1][:int(winw * 1.13) - int(geteaw_count(value[1]) * 0.9)]
                moji3 = value[2][:int(winw * 0.6)]
                fmt = '{:<' + str(int(winw * 1.27) - int(geteaw_count(value[0]))) \
                + '} {:<' + str(int(winw * 1.13) - int(geteaw_count(value[1]))) \
                + '} {:<' + str(int(winw * 0.6)) + '}'
                candidate['abbr'] = fmt.format(moji1,moji2,moji3)
                candidates.append(candidate)
            else:
                self.vim.command('redraw! | echo \'nothing found!!\'')
                return []

        return candidates
