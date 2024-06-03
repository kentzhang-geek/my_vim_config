macro GetCodeLink()
{
	codelink = Ask("Input CodeLink")
	pathandlnum = strmid(codelink, 11, strlen(codelink))

	slen = strlen(pathandlnum)
	var path
	var lnum
	ich = 0
	while (ich < slen)
	{
		ch = pathandlnum[ich]
		if (ch == ":")
		{
			path = strmid(pathandlnum, 0, ich)
			lnum = strmid(pathandlnum, ich+1, strlen(pathandlnum))
		}
		ich = ich + 1
	}
	var headlnum
	headlnum = lnum - 15
	if (headlnum <= 0)
	{
		headlnum = 1
	}

	f = OpenMiscFile(path)
	ScrollWndToLine (GetCurrentWnd(), headlnum)
	SetBufIns (hNil, lnum, 0)
}
