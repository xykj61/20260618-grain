# Stage 4 -- Orchestra of Processes

**Style:** Bhakta at the Door setting, with Radiant warmth
**Status:** Living
**Room:** vision

---

## What this stage teaches

A running program is called a process. An operating system runs many processes
at the same time -- a clock, a file manager, a network listener, a display
renderer, and dozens more, all sharing the same processor and memory.

Keeping those processes organized is like conducting an orchestra. Each
instrument plays its own part, yet they must start together, stay in time, and
stop together. The conductor does not play an instrument -- the conductor
watches all of them at once and makes sure the whole piece holds together.

In Grain, this conductor is called **Caravan**.

## What Caravan does

Caravan manages the life of every process on the system. It handles three
things:

1. **Starting a process.** When the system needs a new process -- a network
   listener, say, or a fresh copy of the file manager -- Caravan creates it,
   gives it the resources it needs (memory from the garden, access to the
   devices it requires), and lets it begin.

2. **Watching a process.** While a process runs, Caravan watches it. If the
   process asks for something it was not granted -- more memory than its bound,
   a device it has no permission to use -- Caravan catches the request and
   returns a named error. The process does not crash. It receives a clear
   answer.

3. **Stopping a process.** When a process finishes its work, or when the system
   needs to shut down, Caravan stops each process in a clean order. The process
   that started last stops first, the way a musician who joined the piece late
   lifts their bow before the opening instruments. This ordering means that
   each process can release its resources without stepping on a process that
   still needs them.

## Dependents

Every process that Caravan manages is called a **dependent** -- something held
up by what it was granted. The word is chosen carefully. A dependent process
depends on the kernel for processor time, on the garden for memory, and on
Caravan itself for permission to run. When any of those grants is withdrawn,
the dependent is stopped cleanly.

Compare this to a program that runs on its own -- it may ask for anything and
grow past any bound. A dependent is watched from the moment it starts to the
moment it stops, and everything it does is bounded by the grants it received.

## The root task

Caravan itself is the first program the kernel starts after it finishes its own
setup. This makes Caravan the **root task** -- the trunk of the tree from Stage
2, the first branch that holds every other branch.

Because Caravan starts first, every other process on the system is its
dependent, directly or through a chain. The file manager is a dependent of
Caravan. The network listener is a dependent of Caravan. The display renderer
is a dependent of Caravan. And Caravan is a dependent of the kernel itself,
which is the root of the whole tree.

This chain means that when the kernel stops, Caravan stops, and every
dependent stops with it -- in order, cleanly, with resources returned. A
shutdown that follows this chain never leaves a stray process running or a
piece of memory unreturned.

## Grants and permissions

When Caravan starts a dependent, it gives that dependent a specific set of
grants:

- **Memory.** A bounded region from the garden, with a named maximum.
- **Devices.** Access to specific hardware -- a serial port, a display, a
  storage device -- and only those devices.
- **Communication.** Permission to send messages to specific other processes,
  and only those processes.

A dependent works within its grants alone. Each process's memory stays its
own. Each device belongs only to the process that received it. Each message
travels only between processes that were introduced. This is the Guardian
Dragon's work at the process level -- safety through explicit permission,
granted before the process begins.

## Something to try

Think of a household. The house itself is the kernel -- the foundation and
the walls. The person managing the household is Caravan -- they decide who
lives there, what each person is responsible for, and how the shared spaces
are used.

Each person in the household is a dependent. They receive a room (memory), a
set of tools they may use (devices), and a list of the other people they work
with (communication). Everyone asks before borrowing tools, and when someone leaves the house,
their room is cleaned and their tools are put away.

That is the discipline: explicit grants, watched use, clean departure. The
orchestra plays because the conductor keeps time.

In the next stage, we will look at how processes keep their work -- the garden
of files where every record is named, stored, and sealed.

---

*An orchestra that knows when each voice enters and when it rests can play
anything. So can a system whose processes are watched, granted, and gently
stopped.*
