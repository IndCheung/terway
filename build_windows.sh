echo "Getting hash ..."
VSC_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
VSC_VERSION=$(git describe --tags --match='v*' --long --abbrev=7 --dirty 2>/dev/null)
VSC_HASH=$(git rev-parse --short HEAD 2>/dev/null)
echo "Getting hash ...VSC_DATE: $VSC_DATE, VSC_VERSION:$VSC_VERSION, VSC_HASH: $VSC_HASH"

echo 'Building terwayd ...'
TERWAYD_BUILD_LDFLAGS="-X 'k8s.io/client-go/pkg/version.buildDate=${VSC_DATE}' -X 'k8s.io/client-go/pkg/version.gitVersion=${VSC_VERSION}' -X 'k8s.io/client-go/pkg/version.gitCommit=${VSC_HASH}' -X 'github.com/AliyunContainerService/terway/pkg/aliyun.kubernetesAlicloudIdentity=Kubernetes.Alicloud/${VSC_HASH}'"; \
GOOS=windows GOARCH=amd64 go build -tags default_build -trimpath -ldflags "$TERWAYD_BUILD_LDFLAGS" -o terwayd.exe ./cmd/terway

echo 'Building terway cni plugin ...'
TERWAY_BUILD_LDFLAGS="-X 'github.com/containernetworking/plugins/pkg/utils/buildversion.BuildVersion=${VSC_VERSION}(${VSC_DATE})'"
GOOS=windows GOARCH=amd64 go build -tags default_build -trimpath -ldflags "$TERWAY_BUILD_LDFLAGS" -o terway.exe ./plugin/terway

echo 'Building terway cli ...'
GOOS=windows GOARCH=amd64 go build -tags default_build -trimpath -o terway-cli.exe ./cmd/terway-cli
echo 'Complete.'
