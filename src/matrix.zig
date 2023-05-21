const std = @import("std");
const Alloc = std.heap.ArenaAllocator;

pub const f32m = struct {
    values: [][]f32,
    rows: usize,
    cols: usize,
    const Self = @This();

    pub fn init(allocator: std.mem.Allocator, cols: usize, rows: usize) !Self {
        var vals: [][]f32 = try allocator.alloc([]f32, cols);
        var i: usize = 0;
        while (i < cols) : (i += 1) {
            vals[i] = try allocator.alloc(f32, rows);
        }
        return .{
            .values = vals,
            .rows = rows,
            .cols = cols,
        };
    }

    pub fn randomise(self: *Self, supplier: std.rand.Random) !void {
        for (self.values, 0..) |col, i| {
            for (col, 0..) |_, j| {
                self.values[i][j] = supplier.float(f32);
            }
        }
    }

    pub fn dot(allocator: std.mem.Allocator, a: Self, b: Self) !Self {
        var returnMatrix = try Self.init(allocator, a.cols, b.rows);
        var colR: usize = 0;
        var rowR: usize = 0;

        while (colR < returnMatrix.cols) : (colR += 1) {
            while (rowR < returnMatrix.rows) : (rowR += 1) {
                returnMatrix.values[colR][rowR] = 0;
            }
        }

        var colA: usize = 0;
        var rowA: usize = 0;
        var colB: usize = 0;
        var rowB: usize = 0;

        while (colA < a.cols) : (colA += 1) {
            while (rowA < a.rows) : (rowA += 1) {
                while (colB < b.cols) : (colB += 1) {
                    while (rowB < b.rows) : (rowB += 1) {
                        returnMatrix.values[colA][rowB] += (a.values[colA][rowA] * b.values[colB][rowB]);
                    }
                    rowB = 0;
                }
                colB = 0;
            }
            rowA = 0;
        }

        return returnMatrix;
    }

    pub fn scalarMult(a: *Self, scalar: f32) !void {
        for (a.values, 0..) |value, i| {
            for (value, 0..) |_, j| {
                a.values[i][j] *= scalar;
            }
        }
    }

    pub fn print(mat: Self) void {
        std.debug.print("matrix: {}x{}\n", .{ mat.cols, mat.rows });
        for (mat.values) |col| {
            std.debug.print("\t", .{});
            for (col) |value| {
                std.debug.print("{3f}  ", .{value});
            }
            std.debug.print("\n", .{});
        }
    }
};
