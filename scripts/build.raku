use Temp::Path;
use Terminal::ANSIColor;
use File::Find;

my $base-dir = $*CWD;
my $data-regex = /'---'\n(<-[-]>+)'---'/;
my $vars-regex = /((<-[:]>+)\:(<-[\n:]>+))* % \n/;

class TagFile {
    has $.tag;
    has $.layout is rw = 'tags';

    method write-tags() {
        my $tag-file = $base-dir.add("_tags/$.tag.md");
        mkdir $tag-file.parent unless $tag-file.parent.d;
        say "Writing to $.tag in $tag-file";
        my $fh = $tag-file.open(:create, :w);
        my $out = qq:to/END/
    ---
    layout: $.layout
    tag-name: $.tag
    ---
    END

                ;
        $fh.spurt: $out;
    }

    method write-feeds() {
        $.layout = 'feed';
        my $tag-file = $base-dir.add("_feeds/$.tag.xml");
        mkdir $tag-file.parent unless $tag-file.parent.d;
        say "Writing to $.tag in $tag-file";
        my $fh = $tag-file.open(:create, :w);
        my $out = qq:to/END/
    ---
    layout: $.layout
    tag-name: $.tag
    ---
    END

                ;
        $fh.spurt: $out;
    }
}


class MentionsProcessor {
    has $.base-url = "https://www.twitter.com/";

    method process($file) {
        my $content = $file.IO.slurp;
        $content ~~ s :g / :my$user = $0;
        '@'(<alnum> *) / [@$0]($.base-url$0)/;
        $file.IO.spurt: $content;
    }

}


sub get-posts($dir) {

    my @files = $dir.IO.dir(:test(*.ends-with('md')));
    my @all-tags;
    my $mp = MentionsProcessor.new();
    for @files -> $file {
        my $content = $file.IO.slurp;
        $mp.process($file);
        my $raw-data = $content.match($data-regex)[0].Str;
        my @matches = $raw-data.match($vars-regex).list;
        my %data =
                @matches.map(-> $match {
                    %(
                        $match[*].list.map(-> $match {
                            my $value;
                            if $match[1].trim ~~ /^\"(.*)\"$/ -> $M {
                                $value = $M[0].Str
                            } else {
                                $value = $match[1].trim
                            }
                            $match[0] => $value
                        })
                    )
                });
        my @tags = %data<tags>.words;
        @all-tags.push: $_ for @tags;
    }
    for @all-tags.unique -> $tag {
        my $tag-file = TagFile.new(:$tag);
        $tag-file.write-tags;
        $tag-file.write-feeds;
    }

}



with make-temp-dir :chmod(0o777) -> $temp {
    put color("bold blue"), "Created Temp Dir for output and pre-processing at: ", color('bold white'), "$temp",
            color('reset');
    put colored("Started copying current project files to the tempt dir..", "bold green");
    run 'cp', '-r', "$base-dir/", "$temp/";
    my $temp-path = "$temp/{ $base-dir.basename }";
    run 'rm', '-rf', "$temp-path/.git", "$temp-path/.idea", "$temp-path/.sass-cache", "$temp-path/scripts",
            "$temp-path/.vscode", "$temp-path/_site";
    get-posts("$temp-path/_posts");
    my $dest-path = make-temp-dir :chmod(0o777);
    my @command = 'bundle', 'exec', 'jekyll', 'build', '-V', '-d', "$dest-path/";
    put colored("Started running: '{ @command.join(' ') }'..", "bold white");
    chdir $temp-path;
    run 'pwd';
    run 'env','JEKYLL_ENV=production','bundle', 'exec', 'jekyll', 'build', '-V', '-d', "$dest-path/";
    chdir $dest-path;
    run 'pwd';
    run 'git','init';
    put "Init Git";
    run 'git', 'remote', 'add','origin','https://github.com/khalidelboray/khalidelboray.github.io.git';
    put "Added Remote";
    run 'git','checkout','-b','gh-pages';
    put "Create Branch";
    run 'git','add','-A';
    run 'git', 'commit', '-m',"Push new changes using the build script",'--allow-empty';
    run 'git','push','origin','gh-pages','--force';
}