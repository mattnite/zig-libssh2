const std = @import("std");
const libssh2 = @import("libssh2.zig");
const mbedtls = @import("mbedtls");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const tls = mbedtls.create(b, target, mode);
    const ssh2 = libssh2.create(b, target, mode);
    tls.link(ssh2);
    ssh2.install();
}
