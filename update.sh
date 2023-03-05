git clone https://github.com/kubescape/kubescape.git --no-checkout
cd kubescape
export VLATEST=$(git describe --tags --abbrev=0)
cd ..
rm -rf kubescape
wget https://github.com/kubescape/kubescape/archive/${VLATEST}.tar.gz
sed -i "s#kubescape/archive/.*#kubescape/archive/${VLATEST}.tar.gz\"#g" kubescape-cli.rb
sed -i "s/^  sha256 \".*/  sha256 \"$(sha256sum ${VLATEST}.tar.gz | cut -d' ' -f1)\"/g" kubescape-cli.rb
rm -rf ${VLATEST}.tar.gz
