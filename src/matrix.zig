const std = @import("std");
const Alloc = std.heap.ArenaAllocator;

fn contains(comptime types: []const type, comptime T: type) bool {
    for (types) |curtype| {
        if (T == curtype) {
            return true;
        }
    }
    return false;
}

pub fn Matrix(comptime T: type) type {
    const allowedTypes = [_]type{
        i8,
        i16,
        i32,
        i64,
        i128,
        f16,
        f32,
        f64,
        f128,
        u8,
        u16,
        u32,
        u64,
        u128,
    };

    if (!contains(&allowedTypes, T)) {
        @compileError("Illegal type");
    }

    return struct {
        vals: []T,
        cols: usize,
        rows: usize,
        alloc: *std.mem.Allocator,

        pub fn init(allocator: *std.mem.Allocator, cols: usize, rows: usize) !Matrix(T) {
            var values: []T = try allocator.alloc(T, rows * cols);
            var i: usize = 0;
            while (i < rows * cols) : (i += 1) {
                values[i] = 0;
            }
            return .{ .alloc = allocator, .vals = values, .rows = rows, .cols = cols };
        }
    };
}
