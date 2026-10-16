#!/usr/bin/env zsh
#
# img_web — make web-sized AVIF *and* WebP copies with a “_web” suffix.
#
# Description
#   - Resizes to a max width (default 1600 px), preserves aspect.
#   - Strips metadata, disables audio.
#   - Always writes TWO outputs per input: <base>_web.avif and <base>_web.webp
#   - Skips inputs whose basename already ends with "_web" (so re-running is safe).
#   - Uses efficient defaults (AVIF CRF 32, WebP quality 75).
#
# Usage
#   img_web [--help|-h] [-w max_width] [-qa avif_crf] [-qw webp_quality] <image...>
#
# Options
#   -w max_width     Max pixel width (default 1600).
#   -qa avif_crf     AVIF CRF (lower=better/larger). Default: 32 (good balance).
#   -qw webp_quality WebP quality (0–100). Default: 75.
#   --help, -h       Show this help and exit.
#
# Notes
#   - Requires ffmpeg with libsvtav1 for AVIF, and the cwebp binary for WebP.
#   - If either is missing, that format is skipped with a warning.
#   - Install missing bits: `brew install ffmpeg webp` (both ship these out of the box).
#
# Examples
#   img_web photo.jpg
#   img_web -w 1200 -qa 30 -qw 70 hero.png banner.jpg
#   img_web *.jpg
#

_img_web_show_help() { sed -n '2,200p' "$0" | awk 'BEGIN{p=0} /^# img_web/{p=1} {if(p)print} /^# Examples/{print; exit}'; }
_img_web_has_enc()   { ffmpeg -hide_banner -loglevel error -encoders | grep -q "$1"; }

img_web() {
  local maxw=1600 avif_crf=32 webp_q=75

  # Accept a bare first numeric arg as width (convenience), e.g., `img_web 1200 *.jpg`
  if [[ $# -gt 0 && $1 == <-> ]]; then
    maxw="$1"
    shift
  fi

  # Parse flags
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help) _img_web_show_help; return 0 ;;
      -w)  maxw="${2:-$maxw}"; shift 2 ;;
      -qa) avif_crf="${2:-$avif_crf}"; shift 2 ;;
      -qw) webp_q="${2:-$webp_q}"; shift 2 ;;
      --) shift; break ;;
      -*) print -u2 "unknown option: $1"; return 2 ;;
      *)  break ;;
    esac
  done

  [[ $# -lt 1 ]] && { print -u2 "usage: $(basename $0) [--help] [-w maxw] [-qa avif_crf] [-qw webp_quality] <image...>"; return 2; }

  local have_avif=0 have_webp=0
  _img_web_has_enc 'libsvtav1' && have_avif=1
  command -v cwebp >/dev/null 2>&1 && have_webp=1
  (( have_avif || have_webp )) || { print -u2 "encoders not found (need ffmpeg's libsvtav1 and/or the cwebp binary — see Notes)"; return 3; }

  local vf="scale='min(${maxw},iw)':'-2':flags=lanczos"

  for f in "$@"; do
    if [[ ! -f "$f" ]]; then
      print -u2 "not found: $f"
      continue
    fi

    local base="${f%.*}"
    local stem="${base##*/}"

    # Skip re-processing already _web inputs
    if [[ "$stem" == *_web ]]; then
      print -u2 "skip (already _web): $f"
      continue
    fi

    # Common decode + resize + strip
    local common=(-hide_banner -loglevel error -y -i "$f" -vf "$vf" -map_metadata -1 -an)

    # AVIF — SVT-AV1 encoder, ffmpeg picks single-frame mode from the .avif container.
    if (( have_avif )); then
      local out_avif="${base}_web.avif"
      ffmpeg "${common[@]}" \
        -c:v libsvtav1 -crf "$avif_crf" -preset 8 \
        -pix_fmt yuv420p \
        "$out_avif" || print -u2 "AVIF encode failed: $f"
      [[ -f "$out_avif" ]] && print "$out_avif"
    else
      print -u2 "skip AVIF (libsvtav1 not available in ffmpeg)"
    fi

    # WebP — cwebp handles decode, resize, strip-metadata, encode in one call.
    # Only resize when source wider than maxw (cwebp's -resize unconditionally scales).
    if (( have_webp )); then
      local out_webp="${base}_web.webp"
      local src_w
      src_w=$(sips -g pixelWidth "$f" 2>/dev/null | awk '/pixelWidth/{print $2}')
      local resize_args=()
      if [[ -n "$src_w" && "$src_w" -gt "$maxw" ]]; then
        resize_args=(-resize "$maxw" 0)
      fi
      cwebp -quiet -mt -metadata none \
        "${resize_args[@]}" -q "$webp_q" -m 6 \
        "$f" -o "$out_webp" || print -u2 "WebP encode failed: $f"
      [[ -f "$out_webp" ]] && print "$out_webp"
    else
      print -u2 "skip WebP (cwebp not available — brew install webp)"
    fi
  done
}

# Run as a script
img_web "$@"

