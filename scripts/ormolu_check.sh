if $(ormolu --mode check $(find . -name '*.hs')); then
    echo "servant-persistent-starter is formatted correctly"
else
    echo "Please run ormolu"
fi
