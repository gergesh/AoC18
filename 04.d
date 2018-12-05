module aoc18;

import std.stdio : writeln;
import std.file : readText, FileException;
import std.string : splitLines, indexOf;
import std.algorithm.sorting : sort;
import std.conv : to;

struct Guard {
    int total_sleep = 0;
    int[60] sleep_per_minute;
}

int sleepiestMin(Guard g) {
    int val = 0, ind;
    foreach (min; 0 .. 60) {
        if (g.sleep_per_minute[min] > val) {
            val = g.sleep_per_minute[min];
            ind = min;
        }
    }

    return ind;
}

Guard[int] parseGuards(string[] lines) {
    Guard[int] guards;
    int gid, start, end;

    sort(lines);
    foreach (line; lines) {
        final switch (line[19]) {
            case 'G': // Guard begins shift
                gid = to!int(line[26 .. indexOf(line, " ", 26)]);
                if (!(gid in guards))
                    guards[gid] = Guard();
                break;
            case 'f': // falls asleep
                start = to!int(line[15 .. 17]);
                break;
            case 'w': // wakes up
                end = to!int(line[15 .. 17]);
                guards[gid].total_sleep += end - start;
                while (end-- != start)
                    guards[gid].sleep_per_minute[end]++;
                break;
        }
    }

    return guards;
}

int main(string[] args) {
    if (args.length != 2) {
        writeln("Usage: ", args[0], " [inputfile]");
        return 2;
    }

    string[] lines;
    try {
        lines = splitLines(readText(args[1]));
    } catch (FileException) {
        writeln("Specified input file does not exist.");
        return 1;
    }

    Guard[int] guards = parseGuards(lines);

    int currGuardSleepiestMinute;
    int p1gid, p1gtm, p1ghs = 0;
    int p2gid, p2gtm, p2ghs = 0;
    foreach (id; guards.keys) {
        currGuardSleepiestMinute = sleepiestMin(guards[id]);

        if (guards[id].total_sleep > p1ghs) {
            p1gid = id;
            p1gtm = currGuardSleepiestMinute;
            p1ghs = guards[id].total_sleep;
        }

        if (guards[id].sleep_per_minute[currGuardSleepiestMinute] > p2ghs) {
            p2gid = id;
            p2gtm = currGuardSleepiestMinute;
            p2ghs = guards[id].sleep_per_minute[currGuardSleepiestMinute];
        }
    }

    writeln("Part 1: ", p1gid * p1gtm);
    writeln("Part 2: ", p2gid * p2gtm);
    return 0;
}
