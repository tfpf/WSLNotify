#include <git2.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>

#ifndef NDEBUG
#define LOG(s, ...) fprintf(stderr, s __VA_OPT__(,) __VA_ARGS__)
#else
#define LOG(s, ...)
#endif

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
    LOG("Opened repository %s.\n", git_repository_path(repo));

    git_reference *ref;
    if (git_repository_head(&ref, repo) != 0)
    {
        LOG("Could not get the HEAD of the repository.\n");
        return;
    }
    char const *branch = git_reference_shorthand(ref);
    LOG("Obtained short name %s.\n", branch);


    // git_status_options opts = GIT_STATUS_OPTIONS_INIT;
    // git_status_list *statuses;
    // if (git_status_list_new(&statuses, repo, &opts))
    // {
    //     /* code */
    // }

}

int
main(void)
{
    git_libgit2_init();
    char git_info[MAX_INFO_LEN] = { '\0' };
    get_git_info(git_info);
    git_libgit2_shutdown();
}
