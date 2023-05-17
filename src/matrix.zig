const std = @import("std");
const Allocator = @import("heap/ArenaAllocator");

pub const TypeError = error.TypeError;

fn contains(comptime types: []const type, comptime T: type) bool {
    for (types) |curtype| {
        if (T == curtype) {
            return true;
        }
    }
    return false;
}

pub fn Matrix(comptime T: type) error{TypeError}!type {
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
        return TypeError;
    }

    return struct { val: [*][*]T, alloc: Allocator };
}
