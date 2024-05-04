#include <git2.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
        LOG("%s\n", git_error_last()->message);
        return;
    }
    char const *repo_path = git_repository_path(repo);
    LOG("Opened repository %s.\n", repo_path);

    char const *bare = "";
    if (git_repository_is_bare(repo) != 0)
    {
        bare = "BARE:";
        LOG("Repository is bare.\n");
    }

    git_reference *ref;
    if (git_repository_head(&ref, repo) != 0)
    {
        LOG("%s\n", git_error_last()->message);
        goto clean_repo;
        return;
    }
    char const *shorthand = git_reference_shorthand(ref);
    LOG("Obtained short name %s.\n", shorthand);

    char shorthand_buf[9];
    if (strcmp(shorthand, "HEAD") == 0)
    {
        switch (git_reference_type(ref))
        {
        case GIT_REFERENCE_DIRECT:
            git_oid const *target = git_reference_target(ref);
            git_oid_tostr(shorthand_buf, sizeof shorthand_buf, target);
            shorthand = shorthand_buf;
            LOG("Repository HEAD directly points to %s.\n", shorthand);
            break;
        case GIT_REFERENCE_SYMBOLIC:
            shorthand = git_reference_symbolic_target(ref);
            LOG("Repository HEAD symbolically points to %s.\n", shorthand);
            break;
        default:
            break;
        }
    }

    // Interactive rebase is not supported. Get the details manually.
    git_rebase_options rebase_opts;
    git_rebase_options_init(&rebase_opts, GIT_REBASE_OPTIONS_VERSION);
    git_rebase *rebase;
    if (git_rebase_open(&rebase, repo, &rebase_opts) != 0)
    {
        LOG("%s\n", git_error_last()->message);
    }

clean_ref:
    git_reference_free(ref);
clean_repo:
    git_repository_free(repo);
}

int
main(void)
{
    git_libgit2_init();
    char git_info[MAX_INFO_LEN] = { '\0' };
    get_git_info(git_info);
    git_libgit2_shutdown();
}
