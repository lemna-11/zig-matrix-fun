const std = @import("std");
const Alloc = std.heap.ArenaAllocator;

const f16m = struct {
    const self = @This();
    var allocator: std.mem.Allocator = undefined;

    pub fn init() !void {}
};
