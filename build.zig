const std = @import("std");
const libssh2 = @import("libssh2.zig");
const mbedtls = @import("mbedtls");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const mbedtls_lib = mbedtls.create(b, target, mode);

    const ssh2 = libssh2.create(b, target, mode);
    ssh2.linkLibrary(mbedtls_lib);
    ssh2.addIncludeDir(mbedtls.include_dir);
    ssh2.install();
}
