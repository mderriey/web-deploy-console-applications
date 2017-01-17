using System;
using System.Configuration;

namespace ConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            var message = ConfigurationManager.AppSettings["DisplayedMessage"];

            Console.WriteLine("Here's the message that is present in the configuration file");
            Console.WriteLine(message);
            Console.ReadLine();
        }
    }
}
