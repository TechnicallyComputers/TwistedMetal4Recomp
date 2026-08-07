#ifndef CODEGEN_SETUP_H
#define CODEGEN_SETUP_H

#include "recomp_launcher.h"

#ifdef __cplusplus
extern "C" {
#endif

void psx_game_codegen_setup_apply(RecompLauncherCGameInfo* gi);
void psx_game_codegen_relaunch_or_exit(const char* disc_path);

#ifdef __cplusplus
}
#endif

#endif
