task :default => "slides.pdf"

file "slides.pdf" => "slides.md" do |t|
    sh "pandoc -t beamer #{t.source} -o #{t.name}"
end

task :clean do
    rm "slides.pdf"
end
