const std = @import("std");

fn root() []const u8 {
    return std.fs.path.dirname(@src().file) orelse ".";
}

fn pathJoinRoot(comptime components: []const []const u8) []const u8 {
    var ret = root();
    inline for (components) |component|
        ret = ret ++ std.fs.path.sep_str ++ component;

    return ret;
}

const srcs = blk: {
    var ret = &.{
        root() ++ "/libssh2/src/channel.c",
        //pathJoinRoot(&.{ "libssh2", "src", "channel.c" }),
        pathJoinRoot(&.{ "libssh2", "src", "comp.c" }),
        pathJoinRoot(&.{ "libssh2", "src", "crypt.c" }),
        pathJoinRoot(&.{ "libssh2", "src", "hostkey.c" }),
        pathJoinRoot(&.{ "libssh2", "src", "kex.c" }),
        pathJoinRoot(&.{ "libssh2", "src", "mac.c" }),
        pathJoinRoot(&.{ "libssh2", "src", "misc.c" }),
        pathJoinRoot(&.{ "libssh2", "src", "packet.c" }),
        pathJoinRoot(&.{ "libssh2", "src", "publickey.c" }),
        pathJoinRoot(&.{ "libssh2", "src", "scp.c" }),
        pathJoinRoot(&.{ "libssh2", "src", "session.c" }),
        pathJoinRoot(&.{ "libssh2", "src", "sftp.c" }),
        pathJoinRoot(&.{ "libssh2", "src", "userauth.c" }),
        pathJoinRoot(&.{ "libssh2", "src", "transport.c" }),
        pathJoinRoot(&.{ "libssh2", "src", "version.c" }),
        pathJoinRoot(&.{ "libssh2", "src", "knownhost.c" }),
        pathJoinRoot(&.{ "libssh2", "src", "agent.c" }),
        pathJoinRoot(&.{ "libssh2", "src", "mbedtls.c" }),
        pathJoinRoot(&.{ "libssh2", "src", "pem.c" }),
        pathJoinRoot(&.{ "libssh2", "src", "keepalive.c" }),
        pathJoinRoot(&.{ "libssh2", "src", "global.c" }),
        pathJoinRoot(&.{ "libssh2", "src", "blowfish.c" }),
        pathJoinRoot(&.{ "libssh2", "src", "bcrypt_pbkdf.c" }),
        pathJoinRoot(&.{ "libssh2", "src", "agent_win.c" }),
    };

    break :blk ret;
};

pub const include_dir = pathJoinRoot(&.{ "libssh2", "include" });
const config_dir = pathJoinRoot(&.{"config"});

pub fn create(
    b: *std.build.Builder,
    target: std.zig.CrossTarget,
    mode: std.builtin.Mode,
) *std.build.LibExeObjStep {
    var ret = b.addStaticLibrary("ssh2", null);
    ret.setTarget(target);
    ret.setBuildMode(mode);
    ret.addIncludeDir(include_dir);
    ret.addIncludeDir(config_dir);
    ret.addCSourceFiles(srcs, &.{});
    ret.linkLibC();

    ret.defineCMacro("LIBSSH2_MBEDTLS", null);
    if (target.isWindows()) {
        ret.defineCMacro("_CRT_SECURE_NO_DEPRECATE", "1");
        ret.defineCMacro("HAVE_LIBCRYPT32", null);
        ret.defineCMacro("HAVE_WINSOCK2_H", null);
        ret.defineCMacro("HAVE_IOCTLSOCKET", null);
        ret.defineCMacro("HAVE_SELECT", null);
        ret.defineCMacro("LIBSSH2_DH_GEX_NEW", "1");

        if (target.getAbi().isGnu()) {
            ret.defineCMacro("HAVE_UNISTD_H", null);
            ret.defineCMacro("HAVE_INTTYPES_H", null);
            ret.defineCMacro("HAVE_SYS_TIME_H", null);
            ret.defineCMacro("HAVE_GETTIMEOFDAY", null);
        }
    } else {
        ret.defineCMacro("HAVE_UNISTD_H", null);
        ret.defineCMacro("HAVE_INTTYPES_H", null);
        ret.defineCMacro("HAVE_STDLIB_H", null);
        ret.defineCMacro("HAVE_SYS_SELECT_H", null);
        ret.defineCMacro("HAVE_SYS_UIO_H", null);
        ret.defineCMacro("HAVE_SYS_SOCKET_H", null);
        ret.defineCMacro("HAVE_SYS_IOCTL_H", null);
        ret.defineCMacro("HAVE_SYS_TIME_H", null);
        ret.defineCMacro("HAVE_SYS_UN_H", null);
        ret.defineCMacro("HAVE_LONGLONG", null);
        ret.defineCMacro("HAVE_GETTIMEOFDAY", null);
        ret.defineCMacro("HAVE_INET_ADDR", null);
        ret.defineCMacro("HAVE_POLL", null);
        ret.defineCMacro("HAVE_SELECT", null);
        ret.defineCMacro("HAVE_SOCKET", null);
        ret.defineCMacro("HAVE_STRTOLL", null);
        ret.defineCMacro("HAVE_SNPRINTF", null);
        ret.defineCMacro("HAVE_O_NONBLOCK", null);
    }

    return ret;
}
