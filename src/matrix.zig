const std = @import("std");
const Alloc = std.heap.ArenaAllocator;

const typeGroup = enum {
    float,
    signed,
    unsigned,
};

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

fn allowed(comptime T: type) bool {
    for (allowedTypes) |curtype| {
        if (T == curtype) {
            return true;
        }
    }
    return false;
}

fn toTypeGroup(comptime T: type) !typeGroup {
    switch (T) {
        u8, u16, u32, u64, u128 => return typeGroup.unsigned,
        i8, i16, i32, i64, i128 => return typeGroup.signed,
        f16, f32, f64, f128 => return typeGroup.float,
        else => @compileError("Type is invalid"),
    }
}

pub fn Matrix(comptime T: type) type {
    if (!allowed(T)) {
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

        pub fn randomise(self: *Matrix(T)) !void {
            var r = std.rand.DefaultPrng.init(42);
            var sup: std.rand.Random = r.random();
            var i: usize = 0;
            while (i < self.rows * self.cols) : (i += 1) {
                switch (try toTypeGroup(T)) {
                    typeGroup.float => {
                        self.vals[i] = @call(std.builtin.CallModifier.auto, sup.float, .{T});
                    },
                    typeGroup.signed, typeGroup.unsigned => {
                        self.vals[i] = @call(std.builtin.CallModifier.auto, sup.int, .{T});
                    },
                }
            }
        }
    };
}
