#!/usr/bin/env bash
# doctor.sh — 영상 편집을 시작하기 전에 딱 한 번 돌린다.
# 여기서 X 가 하나라도 나오면, 그걸 고치기 전에는 편집을 시도하지 마세요.

echo "== 취향 에이전트 · 영상 편집 환경 점검 =="
echo

ok=0; ng=0
chk() { if eval "$2" >/dev/null 2>&1; then echo "  [O] $1"; ok=$((ok+1)); else echo "  [X] $1"; ng=$((ng+1)); fi; }

chk "ffmpeg 설치됨"            "command -v ffmpeg"
chk "ffprobe 설치됨"           "command -v ffprobe"
chk "자막 필터(ass) 있음"       "ffmpeg -hide_banner -filters 2>/dev/null | awk '\$2==\"ass\"{f=1} END{exit !f}'"
chk "자막 필터(subtitles) 있음" "ffmpeg -hide_banner -filters 2>/dev/null | awk '\$2==\"subtitles\"{f=1} END{exit !f}'"
chk "한글 폰트 있음"            "fc-list 2>/dev/null | grep -qiE 'CJK|Gothic|Pretendard' || ls '/System/Library/Fonts/AppleSDGothicNeo.ttc'"
chk "작업 경로에 한글/공백 없음" "printf '%s' \"\$PWD\" | grep -qE '^[A-Za-z0-9/._-]+\$'"

echo
if [ "$ng" -eq 0 ]; then
  echo "전부 통과. bin/make_reel.sh 를 바로 쓰면 됩니다."
  exit 0
fi

cat <<'FIX'
고치는 법
─────────────────────────────────────────────
ffmpeg 없음 / 자막 필터 없음
    맥:      brew reinstall ffmpeg
    우분투:  sudo apt install ffmpeg
    확인:    ffmpeg -filters | grep -E 'ass|subtitles'
    ※ 필터가 없는 ffmpeg 은 자막을 못 굽습니다. PNG 를 겹치거나
      moviepy 를 까는 우회로로 가지 마세요. 그게 대부분의 실패 원인입니다.

한글 폰트 없음
    맥은 기본 탑재(Apple SD Gothic Neo). 우분투: sudo apt install fonts-noto-cjk

작업 경로에 한글/공백 있음
    한글·공백·괄호가 든 경로는 셸에서 계속 깨집니다. 영문 경로로 옮기세요.
        mkdir -p ~/reels/work
    원본 영상도 여기로 복사하고, 파일명은 source.mp4 처럼 단순하게.
FIX
exit 1
