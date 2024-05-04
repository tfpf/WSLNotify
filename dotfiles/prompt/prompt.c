#include <git2.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>

#ifndef NDEBUG
#include <time.h>
#define LOG(s, ...)                                                                                                   \
    do                                                                                                                \
    {                                                                                                                 \
        time_t now = time(NULL);                                                                                      \
        char buf[32];                                                                                                 \
        strftime(buf, sizeof buf, "%F %T", localtime(&now));                                                          \
        fprintf(stderr, "\e[34m%s\e[m \e[94m%s:%d\e[m " s, buf, __FILE__, __LINE__ __VA_OPT__(, ) __VA_ARGS__);       \
    } while (false)
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

    char const *bare = "";
    if (git_repository_is_bare(repo) != 0)
    {
        bare = "BARE:";
        LOG("Repository is bare.\n");
    }

    git_reference *ref;
    if (git_repository_head(&ref, repo) != 0)
    {
        LOG("Could not get HEAD of repository.\n");
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
