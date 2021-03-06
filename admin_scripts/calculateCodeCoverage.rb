#!/usr/bin/env ruby

# A ruby script to display the count of
#   dojos per day
#   dojos per language
#   dojos per exercise
# to see the ids of all counted dojos (in their catagories)
# append true to the command line

require File.dirname(__FILE__) + '/lib_domain'
require 'rubygems'
require 'hpricot'

show_ids = (ARGV[0] || "false")

def deleted_file(lines)
    lines.all? { |line| line[:type] === :deleted }
end

def new_file(lines)
    lines.all? { |line| line[:type] === :added }
end


$dot_count = 0
dojo = create_dojo

$stop_at = 3000000000

puts
days,weekdays,languages,exercises = { },{ },{ },{ }
dot_count = 0
exceptions = [ ]
cyclomaticComplexity = ""
dojo.katas.each do |kata|
    begin
        $dot_count += 1
        language = kata.language.name
        
        kata.avatars.active.each do |avatar|
            if(avatar.lights.last.colour == "amber")
                puts language
                puts avatar.lights.last.colour
            end
            
            if language == "Python-unittest"
                
                #puts "PYTHON"
                #puts avatar.path
                #puts avatar.lights
                #puts avatar.path+ 'sandbox/CodeCoverageReport.csv'
                unless  File.exist?(avatar.path+ 'sandbox/pythonCodeCoverage.csv')
                    
                    puts "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
                    
                    backwardsLights = []
                    avatar.lights.each do |eachLight|
                      backwardsLights.push(eachLight)
                    end
                    #puts backwardsLights.length
                    i = backwardsLights.length-1
                    #puts i
                    while (i > 0)
                        #   puts i
                        curLight = backwardsLights[i]
                        #puts curLight.colour
                        if(curLight.colour.to_s != "amber")
                            break
                            end
                        i -= 1
                    end
                    #puts i
                    puts backwardsLights[i].colour
                    puts avatar.tags[i].visible_files
                    avatar.tags[i].visible_files.each do |gitFile|
                         currfileName =  gitFile[0].to_s
                         puts currfileName
                         #                         '.py' in currfileName
                         if currfileName.include? ".py"
                            dirname = File.dirname("#{avatar.path}lastCompile/")
                            `mkdir #{avatar.path}lastCompile/`

                            File.open("#{avatar.path}lastCompile/"+gitFile[0], "w+") do |f|
                                f.puts(gitFile[1])
                            end
                         end
                    end
                    
                    `rm #{avatar.path}lastCompile/pythonFiles.txt`
                    `rm #{avatar.path}lastCompile/pythonCodeCoverage.csv`
                    `rm -rf #{avatar.path}lastCompile/pythonCodeCoverage`
                    `rm #{avatar.path}lastCompile/*.pyc`
                    
                    allFiles =  Dir.entries(avatar.path+"lastCompile")
                    fileNames = []
                    allFiles.each do |currFile|
                        pythonFile = currFile.to_s =~ /.py/i
                        unless pythonFile.nil?
                            fileNames.push(avatar.path+"lastCompile/"+currFile)
                        end
                        
                    end
                    File.open("#{avatar.path}lastCompile/pythonFiles.txt", "w+") do |f|
                        f.puts(fileNames)
                    end
                    
                    `rm .figleaf`
                    `./figleaf_bin/figleaf #{avatar.path}lastCompile/test*.py `
                    `./figleaf_bin/figleaf2html -f #{avatar.path}lastCompile/pythonFiles.txt -d #{avatar.path}lastCompile/pythonCodeCoverage .figleaf`
                    
                    doc = open(avatar.path+"sandbox/pythonCodeCoverage/index.html") { |f| Hpricot(f) }
                    
                    
                    jsonComplexity = `radon cc #{avatar.path}sandbox/*.py -j`
                    #puts jsonComplexity
                    jsonData = JSON.parse(jsonComplexity)
                    
                    trs =  doc.search("//table//tr[td]")
                    fileCodeCoverageArray = []
                    for i in 1..2
                        individualTableRows = trs[i].search("td")
                        
                        currentFileNameWithPath = individualTableRows[0].at("a").inner_html.to_s
                        sumOfComplexityMetrics = 0
                        #puts currentFileNameWithPath
                        #puts "*********************************"
                        #puts jsonData[currentFileNameWithPath]
                        
                        #puts currentFileNameWithPath
                        #puts jsonData[currentFileNameWithPath]
                        jsonData[currentFileNameWithPath].each do |object|
                            #puts object["complexity"]
                            sumOfComplexityMetrics += object["complexity"]
                            
                        end
                        #               puts "*********************************"
                        
                        #print  "sumOfComplexityMetrics:"
                        #puts sumOfComplexityMetrics
                        
                        fileCodeCoverageArray.push(currentFileNameWithPath+","+individualTableRows[1].inner_html.to_s+","+individualTableRows[2].inner_html.to_s+","+individualTableRows[3].inner_html.to_s+","+sumOfComplexityMetrics.to_s)
                        
                    end
                    
                    #File.delete("#{avatar.path}sandbox/pythonCodeCoverage.csv")
                    File.open("#{avatar.path}sandbox/pythonCodeCoverage.csv", "w+") do |f|
                        f.puts(fileCodeCoverageArray)
                    end
                end
                
            end
            
            if language == "Java-1.8_JUnit"
                #puts avatar.path+ 'CodeCoverageReport.csv'
                #puts "JAVA"
                #   kata.avatars.active.each do |avatar|
                if (File.zero?(avatar.path+ 'CodeCoverageReport.csv'))
                print  "EMPTY "
                puts avatar.path+ 'CodeCoverageReport.csv'
                
                
                
                backwardsLights = []
                avatar.lights.each do |eachLight|
                    backwardsLights.push(eachLight)
                end
                #puts backwardsLights.length
                i = backwardsLights.length-1
                #puts i
                while (i > 0)
                    #   puts i
                    curLight = backwardsLights[i]
                    #puts curLight.colour
                    if(curLight.colour.to_s != "amber")
                        break
                    end
                    i -= 1
                end
                #puts i
                puts backwardsLights[i].colour
                puts avatar.tags[i].visible_files
                avatar.tags[i].visible_files.each do |gitFile|
                    currfileName =  gitFile[0].to_s
                    puts currfileName
                    #                         '.py' in currfileName
                    if currfileName.include? ".java"
                        dirname = File.dirname("#{avatar.path}lastCompile/")
                        `mkdir #{avatar.path}lastCompile/`
                        
                        File.open("#{avatar.path}lastCompile/"+gitFile[0], "w+") do |f|
                            f.puts(gitFile[1])
                        end
                    end
                end




                # unless  File.exist?(avatar.path+ 'CodeCoverageReport.csv')
                    print "ADDING CODE COVERAGE FOR: "
                    puts avatar.path
                    `touch #{avatar.path}CodeCoverageReport.csv`
                    # puts avatar.path
                    #                copyCommand =  "cp "+avatar.path + "sandbox/*.java ./calcCodeCovg/tempDir"
                    `rm -f ./calcCodeCovg/src/*`
                    `rm -r ./calcCodeCovg/isrc/*`
                    `rm -r ./calcCodeCovg/report.csv`
                    `rm -r ./*.clf`
                    
                    puts "cp #{avatar.path}lastCompile/*.java ./calcCodeCovg/src/"
                    
                    `cp #{avatar.path}lastCompile/*.java ./calcCodeCovg/src`
                    
                    allFiles =  Dir.entries("./calcCodeCovg/src/")
                    currTestClass = ""
                    allFiles.each do |currFile|
                        puts currFile
                        initialLoc = currFile.to_s =~ /test/i
                        #puts initialLoc
                        unless initialLoc.nil?
                            fileNameParts = currFile.split('.')
                            currTestClass = fileNameParts.first
                            puts currTestClass
                        end
                    end
                    `java -jar ./calcCodeCovg/libs/codecover-batch.jar instrument --root-directory ./calcCodeCovg/src --destination ./calcCodeCovg/isrc --container ./calcCodeCovg/src/con.xml --language java --charset UTF-8`
                    
                    `javac -cp ./calcCodeCovg/libs/*:./calcCodeCovg/isrc ./calcCodeCovg/isrc/*.java`
                    
                    puts `java -cp ./calcCodeCovg/libs/*:./calcCodeCovg/isrc org.junit.runner.JUnitCore #{currTestClass}`
                    
                    `java -jar ./calcCodeCovg/libs/codecover-batch.jar analyze --container ./calcCodeCovg/src/con.xml --coverage-log *.clf --name test1`
                    
                    puts `java -jar ./calcCodeCovg/libs/codecover-batch.jar report --container ./calcCodeCovg/src/con.xml --destination ./calcCodeCovg/report.csv --session test1 --template ./calcCodeCovg/report-templates/CSV_Report.xml`
                    
                    `cp ./calcCodeCovg/report.csv #{avatar.path}CodeCoverageReport.csv `
                end
            end
        end
        rescue Exception => error
        exceptions << error.message
        
    end
    #dot_count += 1
    break if $dot_count >= $stop_at
    #print "\r " + dots(dot_count)
end
puts
puts


