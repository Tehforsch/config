db="/home/toni/.local/share/Anki2/User 1/collection.anki2"
cp --backup=numbered "$db" /home/toni/.playground/ankiBU/
/home/toni/.cargo-target/release/pundit /home/toni/notes pankit "$db" ~/.pankitDb 2>&1 | tee -a ~/.pankitOut
