---
type: dashboard
tags: [MOC, insight]
---

# 인사이트 재고 대시보드

핵심 지표: **확정 인사이트 10개 이상** 유지 = 2주치 발행 버퍼.

## 발행 대기 (확정)
```dataview
TABLE person, strength, axes
FROM #insight
WHERE status = "확정"
SORT strength DESC
```

## 검증 필요
```dataview
TABLE person, source_url, created
FROM #insight
WHERE status = "미검증"
SORT created ASC
```

## 인물별 수확량
```dataview
TABLE length(rows) AS 개수
FROM #insight
GROUP BY person
SORT length(rows) DESC
```

> Dataview 플러그인이 없으면 위 블록은 코드로만 보입니다.
> 설정 → 커뮤니티 플러그인 → Dataview 설치하면 표로 렌더링됩니다.
> 안 쓸 거면 이 노트를 지우고 수동 체크리스트로 대체하세요.

## 수동 대안 (플러그인 없이)
- [ ] 확정 인사이트 개수: __ / 10
- [ ] 이번 주 새로 추가: __
- [ ] 재고 부족하면 → [[_Ontology-MOC]]의 수집 쿼리 5개 돌리기
