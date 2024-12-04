const std = @import("std");
const data = @embedFile("./dataset");

pub fn main() !void {
    @setEvalBranchQuota(100000);

    var splits = std.mem.splitScalar(u8, data, '\n');
    const line_count: usize = comptime std.mem.count(u8, data, "\n") + 1;

    var vals: [2][line_count]i64 = std.mem.zeroes([2][line_count]i64);

    var row: u32 = 0;
    while (splits.next()) |line| {
        var line_split = std.mem.splitScalar(u8, line, ' ');
        var col: u32 = 0;
        while (line_split.next()) |number| {
            if (number.len > 0) {
                if (std.fmt.parseInt(i64, number, 10)) |value| {
                    vals[col][row] = value;
                } else |_| {
                    std.debug.print("splits: {?s} line_split: {?s} {d}", .{ splits.peek(), line_split.peek(), number.len });
                }
                col += 1;
            }
        }
        row += 1;
    }

    std.mem.sort(i64, &vals[0], {}, comptime std.sort.asc(i64));
    std.mem.sort(i64, &vals[1], {}, comptime std.sort.asc(i64));

    // Part 1
    var total_diff: u64 = 0;
    for (0..line_count) |i| {
        const diff = @abs(vals[0][i] - vals[1][i]);
        total_diff += @abs(diff);
    }
    std.debug.print("Part 1: {d}\n", .{total_diff});

    // Part 2
    var repeated: u32 = 0;
    for (0..line_count) |index| {
        for (0..line_count) |j| {
            if (vals[1][j] == vals[0][index]) {
                repeated += @intCast(vals[0][index]);
            }
        }
    }
    std.debug.print("Part 2: {d}\n", .{repeated});
}
