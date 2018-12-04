module aoc18;

import std.stdio : writeln;
import std.file : readText, FileException;
import std.string : splitLines, indexOf;
import std.algorithm.sorting : sort;
import std.conv : to;
import std.algorithm.searching : maxIndex, maxElement;

struct Nap {
    int start;
    int end;
}

struct Guard {
    int totalsleep = 0;
    Nap[] naps;
}

Guard[int] parseGuards(string[] lines) {
    Guard[int] guards;
    sort(lines);
    int gid, start, end;
    foreach (line; lines) {
        final switch (line[19]) {
            case 'G': // Guard begins shift
                gid = to!int(line[26 .. indexOf(line, " ", 26)]);
                if (!(gid in guards)) {
                    guards[gid] = Guard();
                }
                break;
            case 'f': // falls asleep
                start = to!int(line[15 .. 17]);
                break;
            case 'w': // wakes up
                end = to!int(line[15 .. 17]);
                guards[gid].naps ~= Nap(start, end);
                guards[gid].totalsleep += end - start;
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
    int max = 0, maxID;
    foreach (id; guards.keys) {
        if (guards[id].totalsleep > max) {
            max = guards[id].totalsleep;
            maxID = id;
        }
    }

    int[] napTotal;
    foreach (_; 0..60) {napTotal ~= 0;}
    foreach (nap; guards[maxID].naps) {
        foreach(min; nap.start..nap.end) {
            napTotal[min]++;
        }
    }

    writeln(napTotal.maxIndex * maxID);

    long maxMinutes = 0, maxMinute;
    foreach(id; guards.keys) {
        foreach (x; 0..60) {napTotal[x] = 0;}
        foreach (nap; guards[id].naps) {
            foreach(min; nap.start..nap.end) {
                napTotal[min]++;
            }
        }
        if (napTotal.maxElement > maxMinutes) {
            maxMinutes = napTotal.maxElement;
            maxID = id;
            maxMinute = napTotal.maxIndex;
        }
    }
    writeln(maxID * maxMinute);
    return 0;
}
