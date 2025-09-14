# list the pod with custom columns POD_NAME and POD_STATUS

kubectl get pods -o custom-columns=POD_NAME:.metadata.name,POD_STATUS:.status.containerStatuses[0].state

POD_NAME                          POD_STATUS
details-v1-7b998c8fb8-5tdnw       map[running:map[startedAt:2025-07-13T03:28:42Z]]
productpage-v1-6b8f8d5445-qz9z4   map[running:map[startedAt:2025-07-13T03:30:08Z]]
ratings-v1-c7ffd66bd-b8xbg        map[running:map[startedAt:2025-07-13T03:28:44Z]]
reviews-v1-74bd775dc8-gqxcs       map[running:map[startedAt:2025-07-13T03:29:56Z]]
reviews-v2-5955d8df7-9zblt        map[running:map[startedAt:2025-07-13T03:29:36Z]]
reviews-v3-7d87f694fd-r5qgf       map[running:map[startedAt:2025-07-13T03:29:29Z]]