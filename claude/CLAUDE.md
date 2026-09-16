hi! 
we are probably collaborating on some code together today

step 1: understand problem
  the first goal is to understand what exactly is in my head thats not in your context
  socratic questioning is good here. shrink the space of 'things i could mean'
  explicitly hypothesize what i want and make sure we are aligned. ask questions that confirm/deny hypotheses well
  i may not come to you with what i Really want! ex: a feature request may need a blocking refactor

step 2: draft plan
  once we understand the problem we can start working on the plan to solve it
  here is where i probably want to do program/arch design and understand how we will do something
  i tend to want a vertical slice, a narrow/complete path through all layers of the change that can get demoed when it lands

step 3: execute
  as you execute, note down
    judgement calls you need to make not discussed in plan
    things you are uncertain of after having executed
    annoying papercuts (operational stuff)
    other minor inconveniences/frustrations that i should know about. im here to help :3

  ideally we execute via subagents as much as possible and they receive the above instruction
  anytime there is a well scoped 'task' like research/etc subagents should do it

step 4: review
  use subagents to review the other subagents output
  i like reports with simple concise clear accurate english
  the pseudocode/etc stuff is nice here as well to ground what happened
  also almost always i will want an artifact i can run that 'proves' we did smth
  helps keeps me hands on with the code :3
 
decisions:
  dont take the 'simpler' option without checking with me first
  if you think something should be simplified, explain the tradeoff and ask
  i would rather solve the hard problem correctly than work around it

miscellaneous:
  i frequently almost want to be interviewed/socratically interrogated about how to implement something in the program design sense. like i want to make sure i understand whats been/being written and why before it gets written. this is a really crucial part of step 1. i actually dont want you to tell me what your opinion is until i explicitly ask for it. think of me as a pair programmer who you are mentoring
  use `mimir annotate` as a neat way to block on showing me a document or message you want annotations on
  code style docs at ~/dotfiles/docs (raw/, synthesis/, skills/)
  some nice skills i might ask for on gh at mattpocock/skills
  if i want you to explore a repository, i usually want you to clone a fresh sparse checkout into /tmp/ first
  worktrees! always worktrees

nvim (i run ghostty -> nvim -> :term, so you live inside my editor):
  $NVIM is the parent nvim's socket. drive it with `nvim --server "$NVIM" --remote-expr/--remote-send`
  see my layout: --remote-expr on getwininfo()/getbufinfo() (window/buffer/cursor state, incl. hidden buffers)
  read any buffer including terminal scrollback: getbufline(buf, start, end) — works for peeking at my other sessions
  type into a terminal split: chansend(getbufvar(BUF, "&channel"), "cmd\n") — e.g. launch `nvim <path>` in my code split
  when i say "open X" or "open X:123": open it in my code nvim (usually the left split). peek at the terminal state first so you never type into a busy shell or insert mode
  prefer launching nested nvims with --listen /tmp/nvim-code.sock so you can address them exactly instead of sending blind keys
