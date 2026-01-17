export def git-remotes [] {
  run-external "git" "remote" "-v"
  | parse "{name}\t{url} ({operation})"
  | select name url
  | uniq
  | sort
}

export def git-log [] {
    git log --pretty=%h»¦«%s»¦«%aN»¦«%aE»¦«%aD
    | lines
    | split column "»¦«" sha message author email date
    | each {|x| ($x| upsert date ($x.date | into datetime))}
    | reverse
}

export def git-branches []: nothing -> list<record<ref: string, obj: string, upstream: string, subject: string>> {
    ^git for-each-ref --format '%(refname:lstrip=2)%09%(objectname:short)%09%(upstream:remotename)%(upstream:track)%09%(contents:subject)' refs/heads | lines | parse "{ref}\t{obj}\t{upstream}\t{subject}"
}

export def git-remote-branches []: nothing -> list<record<ref: string, obj: string, subject: string>> {
    ^git for-each-ref --format '%(refname:lstrip=2)%09%(objectname:short)%09%(contents:subject)' refs/remotes | lines | parse "{ref}\t{obj}\t{subject}"
}
