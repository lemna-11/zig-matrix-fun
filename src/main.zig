const std = @import("std");
const mat = @import("matrix.zig");
const allocator = std.heap.ArenaAllocator;
const f16m = mat.Matrix(f16);
const f32m = mat.Matrix(f32);
const u32m = mat.Matrix(u32);
const testing = std.testing;

export fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic add functionality" {
    try testing.expect(add(3, 7) == 10);
}

// uncomment to test whether or not it compiles
// i dont know of a better way to go about this
// if you do, please inform me
// test "compile time type check" {
//     try testing.expectError(std.on, mat.Matrix(bool));
// }

// not supported by current random impl
test "initialise f16 matrix" {
    var arena = allocator.init(std.heap.page_allocator);
    var alloc = arena.allocator();
    defer arena.deinit();
    _ = try f16m.init(&alloc, 5, 5);
}

test "initialise f32 matrix" {
    var arena = allocator.init(std.heap.page_allocator);
    var alloc = arena.allocator();
    defer arena.deinit();
    _ = try f32m.init(&alloc, 5, 5);
}

test "initialise u32 matrix" {
    var arena = allocator.init(std.heap.page_allocator);
    var alloc = arena.allocator();
    defer arena.deinit();
    var rows: usize = 10;
    var cols: usize = 10;
    const m = try u32m.init(&alloc, rows, cols);
    var i: usize = 0;
    while (i < rows * cols) : (i += 1) {
        try testing.expect(m.vals[i] == 0);
    }
}

test "randomise f32 matrix" {
    var arena = allocator.init(std.heap.page_allocator);
    var alloc = arena.allocator();
    defer arena.deinit();
    var rows: usize = 10;
    var cols: usize = 10;
    var m = try f32m.init(&alloc, rows, cols);
    try m.randomise();
}

test "randomise u32 matrix" {
    var arena = allocator.init(std.heap.page_allocator);
    var alloc = arena.allocator();
    defer arena.deinit();
    var rows: usize = 10;
    var cols: usize = 10;
    var m = try u32m.init(&alloc, rows, cols);
    try m.randomise();
}
