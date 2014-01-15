gfalist converts .GFA binary files to .LST files.
It allows generating listings from binary GFA BASIC files.

It can be used along with git to get text diffs on GFA files (but not merges):

    # make sure you have gfalist in your $PATH
    
    $ git diff
    diff --git a/test.gfa b/test.gfa
    index 9dfbbd6..b8612d8 100644
    Binary files a/test.gfa and b/test.gfa differ
    $ git config --local diff.gfa.textconv 'gfalist -c'
    $ echo '*.gfa diff=gfa' >> .gitattributes
    $ git diff
    diff --git a/test.gfa b/test.gfa
    index 9dfbbd6..b8612d8 100644
    --- a/test.gfa
    +++ b/test.gfa
    @@ -0,0 +1 @@
    +QUIT 0

Original readme below.

OUR NEXT STEP -- The GFABASIC4 development package
Copyright (C) 1992-2001  Peter Backes

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; version 2 of the License, not any 
earlier or later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

