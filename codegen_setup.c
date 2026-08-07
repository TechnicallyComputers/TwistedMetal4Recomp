/* Title config for psxrecomp/host/psxrecomp_codegen_host.
 * Wired only when the build opts into -DPSX_SETUP_WIZARD=ON. */

#include "codegen_setup.h"

#include "psxrecomp_codegen_host.h"

static const PsxrecompCodegenHostConfig kCodegenConfig = {
    .display_name = "TwistedMetal4",
    .project_root_env = "TWISTEDMETAL4RECOMP_PROJECT_ROOT",
    .build_dir_env = "TWISTEDMETAL4RECOMP_BUILD_DIR",
    .force_setup_env = "TWISTEDMETAL4RECOMP_FORCE_SETUP",
    .psxrecomp_cli_relpath = "psxrecomp/psxrecomp_cli.py",
    .seed_cfg_relpath = "game.toml",
    .game_toml_relpath = "game.toml",
    .gen_marker_relpath = "generated/SCUS_945.60_dispatch.c",
    .build_dir_name = "build-release",
    .cmake_target = "psx-runtime",
    .exe_basename = "TwistedMetal4_Recompiled",
    .prepare_note =
        "Uses your legal disc with the local psxrecomp SDK to generate "
        "BIOS + game C, then cmake --build and restart.",
    .prepare_note_windows =
        "Uses your legal disc with the local psxrecomp SDK to generate "
        "BIOS + game C, then quits and rebuilds via a helper.",
    .prepare_note_no_cmake =
        "Uses your legal disc with the local psxrecomp SDK to generate "
        "BIOS + game C. Rebuild manually, then relaunch.",
};

void psx_game_codegen_setup_apply(RecompLauncherCGameInfo* gi) {
    psxrecomp_codegen_host_apply(gi, &kCodegenConfig);
}

void psx_game_codegen_relaunch_or_exit(const char* disc_path) {
    psxrecomp_codegen_host_relaunch_or_exit(disc_path);
}
