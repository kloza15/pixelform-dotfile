#!/bin/bash

# ===================================================================
#       GitHub Release Manager — Smart Edition (v4.0)
#       Auto-Detects Local Repo & Centralized Auth
# ===================================================================

# حفظ التوكن في مجلد المستخدم الرئيسي ليعمل مع كل المشاريع
CONFIG_FILE="$HOME/.gh_release_config"

# ---------- Colors ----------
BOLD="\e[1m"
RESET="\e[0m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
WHITE="\e[97m"

# ---------- Helper Functions ----------

header() {
    clear
    echo -e "${MAGENTA}${BOLD}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                GitHub Release Manager v4.0                   ║"
    echo "║           Smart Auto-Detection & Remote Linking              ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
}

confirm() {
    attempts=0
    while [[ $attempts -lt 3 ]]; do
        echo -ne "${YELLOW}Are you sure? (y/n): ${RESET}"
        read ans
        case "$ans" in
            y|Y) return 0 ;; 
            n|N) echo -e "${RED}❌ Cancelled.${RESET}"; return 1 ;;
            *) echo -e "${RED}Type 'y' or 'n'.${RESET}"; ((attempts++)) ;;
        esac
    done
    return 1
}

# ---------- Authentication & Setup ----------

load_credentials() {
    # التحقق من وجود ملف الإعدادات في مجلد المستخدم
    if [[ -f "$CONFIG_FILE" ]]; then
        source "$CONFIG_FILE"
    fi

    # إذا لم يكن التوكن موجوداً، نطلبه
    if [[ -z "$USERNAME" || -z "$TOKEN" ]]; then
        header
        echo -e "${YELLOW}⚠ First time setup (Credentials will be saved globally in ~/.gh_release_config)${RESET}"
        read -p "GitHub Username: " USERNAME
        read -s -p "GitHub Token (Repo scope required): " TOKEN 
        echo ""
        
        # حفظ التوكن فقط (بدون اسم الريبو لضمان المرونة)
        echo "USERNAME=\"$USERNAME\"" > "$CONFIG_FILE"
        echo "TOKEN=\"$TOKEN\"" >> "$CONFIG_FILE"
        echo -e "${GREEN}✔ Credentials saved securely.${RESET}"
        sleep 1
    fi
}

# ---------- Smart Repo Detection ----------

detect_or_select_repo() {
    # 1. Check if git is initialized
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo -e "${YELLOW}⚠ This folder is not a git repository.${RESET}"
        echo -e "${CYAN}Initializing git...${RESET}"
        git init -b main
    fi

    # 2. Try to get remote URL from local git config
    REMOTE_URL=$(git remote get-url origin 2>/dev/null)
    
    if [[ -n "$REMOTE_URL" ]]; then
        # استخراج اسم الريبو من الرابط (يدعم SSH و HTTPS)
        # Pattern: github.com/user/repo.git or github.com:user/repo.git
        CURRENT_REPO=$(echo "$REMOTE_URL" | sed -n 's/.*github.com[:\/]\(.*\).git/\1/p')
        
        # إذا فشل الاستخراج (مثلاً الرابط لا ينتهي بـ .git)
        if [[ -z "$CURRENT_REPO" ]]; then
             CURRENT_REPO=$(echo "$REMOTE_URL" | sed -n 's/.*github.com[:\/]\(.*\)/\1/p')
        fi

        if [[ -n "$CURRENT_REPO" ]]; then
            REPO="$CURRENT_REPO"
            echo -e "${GREEN}✔ Detected linked repository: ${BOLD}$REPO${RESET}"
            return 0
        fi
    fi

    # 3. If no remote found, ask user to select from API and LINK IT
    echo -e "${YELLOW}⚠ No remote repository linked to this folder.${RESET}"
    select_repo_from_api
}

select_repo_from_api() {
    if ! command -v jq &> /dev/null; then
        echo -e "${RED}❌ 'jq' is missing. Install it: sudo apt install jq${RESET}"; exit 1
    fi

    echo -e "${CYAN}▶ Fetching your repositories from GitHub...${RESET}"
    
    REPOS_JSON=$(curl -s -H "Authorization: token $TOKEN" "https://api.github.com/user/repos?sort=updated&per_page=100")
    
    # Check for authentication error
    if echo "$REPOS_JSON" | grep -q "Bad credentials"; then
        echo -e "${RED}❌ Bad credentials. Please delete ~/.gh_release_config and try again.${RESET}"
        exit 1
    fi

    REPOS_DATA=$(echo "$REPOS_JSON" | jq -r '.[] | .full_name + "|" + (.private | tostring)')
    
    if [[ -z "$REPOS_DATA" ]]; then
        echo -e "${RED}❌ No repositories found.${RESET}"; exit 1
    fi

    REPO_ARRAY=($REPOS_DATA)
    i=1
    echo -e "${YELLOW}Select a repository to link to this folder:${RESET}"
    
    for item in "${REPO_ARRAY[@]}"; do
        FULL_NAME=$(echo "$item" | cut -d'|' -f1)
        IS_PVT=$(echo "$item" | cut -d'|' -f2)
        [[ "$IS_PVT" == "true" ]] && VIS="🔒 Private" || VIS="🌍 Public"
        echo "  [$i] $FULL_NAME ($VIS)"
        ((i++))
    done

    echo -e "${CYAN}------------------------------------------${RESET}"
    read -p "Enter number: " idx
    
    if [[ "$idx" =~ ^[0-9]+$ ]] && (( idx >= 1 && idx <= ${#REPO_ARRAY[@]} )); then
        SELECTED="${REPO_ARRAY[$((idx - 1))]}"
        REPO=$(echo "$SELECTED" | cut -d'|' -f1)
        
        echo -e "${GREEN}✔ Selected: $REPO${RESET}"
        
        # أهم خطوة: ربط المجلد المحلي بالريبو المختار
        echo -e "${CYAN}▶ Linking local folder to remote origin...${RESET}"
        git remote remove origin 2>/dev/null
        git remote add origin "https://$USERNAME:$TOKEN@github.com/$REPO.git"
        
        echo -e "${GREEN}✔ Successfully linked!${RESET}"
    else
        echo -e "${RED}Invalid selection.${RESET}"; exit 1
    fi
}

# ---------- Operations ----------

get_last_tag() {
    git fetch --tags >/dev/null 2>&1
    last_tag=$(git tag --sort=-v:refname | head -n 1)
    [[ -z "$last_tag" ]] && last_tag="v0.0.0"
}

push_main() {
    header
    echo -e "${CYAN}▶ Processing repository: ${BOLD}$REPO${RESET}"
    
    # التأكد من تحديث الـ Remote URL بالتوكن لضمان الصلاحيات
    git remote set-url origin "https://$USERNAME:$TOKEN@github.com/$REPO.git"

    echo -e "${CYAN}▶ Staging and Committing...${RESET}"
    git add .
    git commit -m "Auto Update: $(date '+%Y-%m-%d %H:%M')" 2>/dev/null
    
    echo -e "${CYAN}▶ Pulling latest changes (Rebase)...${RESET}"
    git pull origin main --rebase
    
    echo -e "${CYAN}▶ Pushing to main...${RESET}"
    if git push origin main; then
        echo -e "${GREEN}✔ Main branch updated successfully.${RESET}"
    else
        echo -e "${RED}❌ Failed to push. Check for conflicts.${RESET}"
    fi
}

create_tag() {
    header
    get_last_tag
    echo -e "Current Repo: ${MAGENTA}$REPO${RESET}"
    echo -e "Last Tag: ${GREEN}$last_tag${RESET}"
    echo ""

    # اقتراح الإصدار التالي
    clean_last="${last_tag#v}"
    IFS='.' read -r major minor patch <<< "$clean_last"
    [[ -z "$patch" ]] && patch=0
    new_patch=$((patch + 1))
    suggested="v$major.$minor.$new_patch"

    read -e -i "$suggested" -p "Enter new tag version: " new_tag

    if git rev-parse "$new_tag" >/dev/null 2>&1; then
        echo -e "${RED}❌ Tag already exists.${RESET}"; return
    fi

    confirm || return

    git tag "$new_tag"
    echo -e "${CYAN}▶ Pushing tag $new_tag...${RESET}"
    git push origin "$new_tag"
    echo -e "${GREEN}✔ Tag published successfully!${RESET}"
}

delete_tag() {
    header
    tags=($(git tag --sort=-v:refname))
    if [[ ${#tags[@]} -eq 0 ]]; then echo -e "${RED}No tags.${RESET}"; return; fi

    echo -e "${YELLOW}Select tag to delete:${RESET}"
    i=1
    for t in "${tags[@]}"; do
        if [ $i -gt 15 ]; then break; fi # Limit display
        echo " [$i] $t"
        ((i++))
    done

    read -p "Select number: " num
    if [[ "$num" =~ ^[0-9]+$ ]] && (( num >= 1 && num <= ${#tags[@]} )); then
        del_tag="${tags[$((num-1))]}"
        echo -e "${RED}Deleting $del_tag ...${RESET}"
        confirm || return
        
        git tag -d "$del_tag"
        git push origin --delete "$del_tag"
        echo -e "${GREEN}✔ Deleted.${RESET}"
    fi
}

# ---------- Main Menu ----------

menu() {
    while true; do
        header
        # دائماً أعد التحقق من الريبو في كل دورة
        detect_or_select_repo
        get_last_tag

        echo -e "${MAGENTA}Active Repo: ${WHITE}${BOLD}$REPO${RESET}"
        echo -e "${CYAN}Last Tag:    ${GREEN}$last_tag${RESET}"
        echo -e "${CYAN}Config Path: ${GRAY}$CONFIG_FILE${RESET}"
        echo ""
        echo "  [1] 🚀 Push Changes (Commit & Push)"
        echo "  [2] 🏷️  Create New Release (Tag)"
        echo "  [3] 🗑️  Delete Existing Tag"
        echo "  [4] 🔄 Relink/Change Repository"
        echo "  [0] ❌ Exit"
        echo ""
        read -p "Choose: " c

        case $c in
            1) push_main; read -p "Enter..." ;;
            2) create_tag; read -p "Enter..." ;;
            3) delete_tag; read -p "Enter..." ;;
            4) select_repo_from_api; read -p "Enter..." ;; # إجبار الاختيار اليدوي
            0) exit ;;
            *) echo "Invalid"; sleep 1 ;;
        esac
    done
}

# التنفيذ
load_credentials
menu