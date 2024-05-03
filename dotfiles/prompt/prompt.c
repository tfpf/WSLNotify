#include <git2.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>

#define LOG(s, ...) fprintf(stderr, s __VA_OPT__(,) __VA_ARGS__)

enum
{
    MAX_INFO_LEN = 64
};

/******************************************************************************
 * Obtain the current state of the current Git repository.
 *
 * @param git_info String to write the state to.
 *****************************************************************************/
void
get_git_info(char git_info[])
{
    git_repository *repo;
    if (git_repository_open_ext(&repo, ".", 0, NULL) != 0)
    {
        LOG("Could not open repository.\n");
        return;
    }
}

int
main(void)
{
    git_libgit2_init();
    char git_info[MAX_INFO_LEN] = { '\0' };
    get_git_info(git_info);
    git_libgit2_shutdown();

    printf("%s\n", git_info);
}
