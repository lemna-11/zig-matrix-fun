const std = @import("std");
const Alloc = std.heap.ArenaAllocator;

pub const f32m = struct {
    values: [][]f32,
    alloc: std.mem.Allocator,
    const Self = @This();

    pub fn init(allocator: std.mem.Allocator, cols: usize, rows: usize) !Self {
        var vals: [][]f32 = try allocator.alloc([]f32, cols);
        var i: usize = 0;
        while (i < rows) : (i += 1) {
            vals[i] = try allocator.alloc(f32, rows);
        }
        return .{
            .values = vals,
            .alloc = allocator,
        };
    }

    pub fn randomise(self: *Self, supplier: std.rand.Random) !void {
        for (self.values, 0..) |col, i| {
            for (col, 0..) |_, j| {
                self.values[i][j] = supplier.float(f32);
            }
        }
    }
};
