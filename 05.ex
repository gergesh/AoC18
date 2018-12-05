# In order to run:
# $ iex
# > c("05.ex")
# > AoC18.solve("inputs/05")

defmodule AoC18 do
    def react([x | xs], [head | stack], skipped, running_length) do
        if x == skipped or skipped - x == 32 do
            react(xs, [head | stack], skipped, running_length)
        else
            if abs(x - head) == 32 do
                react(xs, stack, skipped, running_length - 1)
            else
                react(xs, [x | [head | stack]], skipped, running_length + 1)
            end
        end
    end

    def react([], _, _, running_length) do
        running_length - 1 # length(list) is an O(n) operation
    end

    def solve(fname) do
        {:ok, s} = File.read fname
        cl = String.to_charlist(s)
        IO.puts(react(cl, [0,], 0, 0))
        IO.puts(Enum.min(for x <- ?a..?z, do: react(cl, [0,], x, 0)))
    end
end
