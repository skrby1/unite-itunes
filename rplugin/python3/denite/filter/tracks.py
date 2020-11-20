from denite.base.filter import Base
from denite.util import UserContext, Candidates


class Filter(Base):

    def __init__(self, vim) -> None:
        super().__init__(vim)

        self.name = 'sorter/tracks'
        self.description = 'sort candidates for tracks'

    def filter(self, context: UserContext) -> Candidates:
        return sorted(sorted(sorted(context['candidates'],
                key=lambda a: str(a['artist']).lower()),
                key=lambda b: int(b['tkno'])),
                key=lambda c: str(c['album']).lower())
