import os
import shlex
import unicodedata

from subprocess import CalledProcessError, check_output, run, PIPE
from denite.base.source import Base

def get_eaw_count(text):
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
        self.sorters = ['sorter/albums']
        self.matchers = ['matcher/regexp']
        self.vars = {'winw': int(self.vim.funcs.winwidth(0) / 3)}
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

        candidates = []
        value = []
        for entry in plists:
            value = entry.split('\t')
            if value[0]:
                candidate = {}
                candidate['word'] = value[0] + ' ' + value[1] + ' ' + value[2]
                candidate['name'] = value[0]
                candidate['album'] = value[1]
                candidate['artist'] = value[2]
                candidate['tkno'] = value[3]
                candidate['id'] = value[4]
                candidate['plname'] = value[5]
                candidate['ptime'] = value[6]
                candidate['sartist'] = value[7]
                candidate['plflag'] = plflag
                moji1 = self.adjust_str(value[0], 1.27)
                moji2 = self.adjust_str(value[1], 1.13)
                moji3 = self.adjust_str(value[2], 0.6)
                fmt = moji1[1] + moji2[1] + moji3[1][:-1]
                candidate['abbr'] = fmt.format(moji1[0],moji2[0],moji3[0])
                candidates.append(candidate)
            else:
                self.vim.command('redraw! | echo \'nothing found!!\'')
                return []

        if value[8] == "playlist":
            self.sorters = ['sorter/playlist']
        elif value[8] == 'title' or value[8] == 'year':
            self.sorters = ['sorter/artists']
        elif value[8] == 'time':
            self.sorters = ['sorter/times']

        return candidates

    def adjust_str(self, text: str, size: float):
            while (len(text.encode('utf-8')) - get_eaw_count(text))\
                    >= int(self.vars['winw'] * size):
                text = text[:-1]
            fmt = '{:<' + str(int(self.vars['winw'] * size)
                    - (len(text.encode('utf-8')) - len(text) - get_eaw_count(text))) + '} '
            return [text, fmt]
