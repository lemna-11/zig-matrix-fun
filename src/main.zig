const std = @import("std");
const mat = @import("matrix.zig");
const rand = std.rand.DefaultPrng;
const allocator = std.heap.ArenaAllocator;
const testing = std.testing;

test "init test" {
    var a = allocator.init(std.heap.page_allocator);
    var alloc = a.allocator();
    _ = try mat.f32m.init(alloc, 5, 5);
}

test "randomise test" {
    var a = allocator.init(std.heap.page_allocator);
    var alloc = a.allocator();
    var r = rand.init(42);
    var matr = try mat.f32m.init(alloc, 5, 5);
    try matr.randomise(r.random());
}
