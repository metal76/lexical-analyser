using System;
using System.IO;
using System.Collections.Generic;
using SimpleScanner;
using SimpleParser;
using System.Collections;

namespace SimpleCompiler
{
    public class SimpleCompilerMain
    {
        static bool two_cycles()
        {
            StreamReader objReader = new StreamReader(@"..\..\a.txt");
            string sLine = "";
            ArrayList arrText = new ArrayList();

            while (sLine != null)
            {
                sLine = objReader.ReadLine();
                if (sLine != null)
                    arrText.Add(sLine);
            }
            objReader.Close();
            List<int> iters = new List<int>() {0,0 };
            int q = 0;
            foreach (string sOutput in arrText)
                if (sOutput.IndexOf("for")>=0)
                {
                    List<int> startendstep = new List<int>() {0,0,0 };
                    int j = 0;
                    for (int i=0; i < sOutput.Length; i = i + 1)
                    {
                        if(char.IsDigit(sOutput[i]))
                        {
                            while(char.IsDigit(sOutput[i]))
                            {
                                startendstep[j] = startendstep[j] * 10+ int.Parse(sOutput[i].ToString());
                                i++;
                            }
                            j++;
                        }
                        if (j >= 3)
                            break;
                    }
                    if (startendstep[2] == 0) { startendstep[2] += 1; }
                    int x = (startendstep[1] - startendstep[0] + (startendstep[2] - 1));
                    int y = (startendstep[2]);
                    int z = x / y;
                    iters[q] = (startendstep[1] - startendstep[0]+ (startendstep[2]-1))/ (startendstep[2]);
                    ++q;
                }
                    ;
                return iters[0]==iters[1];
        }
        public static void Main()
        {
            string FileName = @"..\..\a.txt";
            try
            { 
                string Text = File.ReadAllText(FileName);

                Scanner scanner = new Scanner();
                scanner.SetSource(Text, 0);
            
                Parser parser = new Parser(scanner);
                      
                var b = parser.Parse();
                if (!b)

                    Console.WriteLine("Ошибка");
                else {
                    //if (two_cycles())
                    Console.WriteLine("Программа распознана");
                   // else
                   //     Console.WriteLine("Некорректные параметры циклов");
                };
            }
            catch (FileNotFoundException)
            {
                Console.WriteLine("Файл {0} не найден", FileName);
            }
            catch (LexException e)
            {
                Console.WriteLine("Лексическая ошибка. " + e.Message);
            }
            catch (SyntaxException e)
            {
                Console.WriteLine("Синтаксическая ошибка. " + e.Message);
            }

            Console.ReadLine();


     }

    }
}
