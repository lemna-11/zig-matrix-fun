const std = @import("std");
const mat = @import("matrix.zig");
const testing = std.testing;

export fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic add functionality" {
    try testing.expect(add(3, 7) == 10);
}

test "compile time type check" {
    try testing.expectError(mat.TypeError, mat.Matrix(bool));
}
