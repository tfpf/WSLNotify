#include <cstddef>
#include <cstdlib>
#include <format>
#include <git2.h>
#include <iomanip>
#include <iostream>
#include <string>

#ifndef NDEBUG
#include <chrono>
#define LOG(s)                                                                                                        \
    do                                                                                                                \
    {                                                                                                                 \
        std::time_t now = std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());                     \
        std::clog << "\e[34m" << std::put_time(std::localtime(&now), "%F %T") << "\e[m ";                             \
        std::clog << "\e[94m" << __FILE__ << ':' << __LINE__ << "\e[m ";                                              \
        std::clog << s << '\n';                                                                                       \
    } while (false)
#else
#define LOG(s)
#endif

/******************************************************************************
 * Obtain the current state of the current Git repository.
 *
 * @return String describing state if in a Git repository, else empty string.
 *****************************************************************************/
std::string
get_git_info(void)
{
    git_repository* repo;
    if (git_repository_open_ext(&repo, ".", 0, NULL) != 0)
    {
        LOG(git_error_last()->message);
        return "";
    }
    char const* repo_path = git_repository_path(repo);
    LOG("opened repository " << repo_path);

    char const* bare = "";
    if (git_repository_is_bare(repo) != 0)
    {
        bare = "BARE:";
        LOG("repository is bare");
    }

    git_reference* ref;
    if (git_repository_head(&ref, repo) != 0)
    {
        LOG(git_error_last()->message);
        git_repository_free(repo);
        return "";
    }
    char const* shorthand = git_reference_shorthand(ref);
    LOG("obtained HEAD name " << shorthand);

    char shorthand_buf[9];
    if (std::string(shorthand) == "HEAD")
    {
        git_reference_t reftype = git_reference_type(ref);
        if (reftype == GIT_REFERENCE_DIRECT)
        {
            git_oid const* target = git_reference_target(ref);
            git_oid_tostr(shorthand_buf, sizeof shorthand_buf, target);
            shorthand = shorthand_buf;
            LOG("HEAD directly points to " << shorthand);
        }
        else if (reftype == GIT_REFERENCE_SYMBOLIC)
        {
            shorthand = git_reference_symbolic_target(ref);
            LOG("HEAD symbolically points to " << shorthand);
        }
    }

    char const* shorthand_begin = "\e[32m";
    char const* shorthand_end = "\e[m";
    if (git_repository_head_detached(repo))
    {
        shorthand_begin = "\e[31m";
    }

    return std::format("   {}{}{}{}", shorthand_begin, bare, shorthand, shorthand_end);
}

/******************************************************************************
 * Obtain the current Python virtual environment.
 *
 * @return Name of the virtual environment if any, else empty string.
 *****************************************************************************/
std::string
get_venv_info(void)
{
    char const* venv_prompt = std::getenv("VIRTUAL_ENV_PROMPT");
    if (venv_prompt == NULL)
    {
        LOG("VIRTUAL_ENV_PROMPT is unset");
        return "";
    }
    LOG("VIRTUAL_ENV_PROMPT is set to " << venv_prompt);
    return std::format("  \e[94m{}\e[m", venv_prompt);
}

int
main(void)
{
    git_libgit2_init();
    std::string git_info = get_git_info();
    git_libgit2_shutdown();
    LOG("git_info = " << git_info);

    std::string venv_info = get_venv_info();
    LOG("venv_info = " << venv_info);

    std::cout << git_info << venv_info << '\n';
}
