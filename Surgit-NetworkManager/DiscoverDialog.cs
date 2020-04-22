﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.Net;
using System.Net.NetworkInformation;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Windows.Forms;
using Syncfusion.WinForms.Controls;

namespace Surgit_NetworkManager
{
    public partial class DiscoverDialog : SfForm
    {
        public DiscoverDialog()
        {
            InitializeComponent();
        }

        private Thread discoveryThread = null;

        private void BtnStartDiscovery_Click(object sender, EventArgs e)
        {
            bool ipStartValid = false;
            bool ipEndValid = false;

            // Check if start-IP is valid
            if(IPAddress.TryParse(txbDiscoveryStart.Text, out IPAddress ipStartRange) && ipStartRange.AddressFamily == System.Net.Sockets.AddressFamily.InterNetwork) ipStartValid = true;
            else
            {
                MessageBox.Show("The given range-start is not a valid IPv4-Address", "Invalid IP", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            // Check if end-IP is valid
            if (IPAddress.TryParse(txbDiscoveryStart.Text, out IPAddress ipEndRange) && ipEndRange.AddressFamily == System.Net.Sockets.AddressFamily.InterNetwork) ipEndValid = true;
            else
            {
                MessageBox.Show("The given range-end is not a valid IPv4-Address", "Invalid IP", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            // Check if the start and end IPs are in the same subnet and that they are in a class C subnet
            if(ipStartValid && ipEndValid)
            {
                string[] ipStartParts = txbDiscoveryStart.Text.Split('.');
                string[] ipEndParts = txbDiscoveryEnd.Text.Split('.');

                if(ipStartParts[0] == ipEndParts[0] && ipStartParts[1] == ipEndParts[1] && ipStartParts[2] == ipEndParts[2])
                {
                    new Thread(delegate () {
                        Discover(ipStartParts, ipEndParts);
                    }).Start();
                }
                else
                {
                    MessageBox.Show("The given range is not valid. Make sure the IPs are in the same subnet. Note: Only C-Class IP-Adresses are currently supported", "Invalid Range", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }
            }
        }

        private void Discover(string[] ipStartParts, string[] ipEndParts)
        {
            txbDiscoveryOutput.Text = "";

            int deviceCount = 0;

            int rangeSize = 0;

            rangeSize = Convert.ToInt32(ipEndParts[3]) - Convert.ToInt32(ipStartParts[3]);

            prbDiscoveryProgress.Value = 0;
            prbDiscoveryProgress.Minimum = 0;
            prbDiscoveryProgress.Maximum = rangeSize;

            if (chbPingCheck.Checked)
            {
                rangeSize *= 2;
                prbDiscoveryProgress.Maximum = rangeSize;

                txbDiscoveryOutput.Text += "Starting ping-check..." + Environment.NewLine;

                for (int i = Convert.ToInt32(ipStartParts[3]); i <= Convert.ToInt32(ipEndParts[3]); i++)
                {
                    string currentIP = ipStartParts[0] + "." + ipStartParts[1] + "." + ipStartParts[2] + "." + i.ToString();

                    try
                    {
                        Ping ping = new Ping();
                        ping.Send(currentIP, 500);

                        txbDiscoveryOutput.Text += "Sent Ping to " + currentIP + Environment.NewLine;
                        txbDiscoveryOutput.SelectionStart = txbDiscoveryOutput.TextLength;
                        txbDiscoveryOutput.ScrollToCaret();
                    }
                    catch (Exception)
                    { }

                    if (prbDiscoveryProgress.Value < prbDiscoveryProgress.Maximum)
                        prbDiscoveryProgress.Value++;
                }
            }

            

            

            txbDiscoveryOutput.Text += "Starting discovery..." + Environment.NewLine;
            txbDiscoveryOutput.SelectionStart = txbDiscoveryOutput.TextLength;
            txbDiscoveryOutput.ScrollToCaret();

            // Start the discovery
            for (int i = Convert.ToInt32(ipStartParts[3]); i <= Convert.ToInt32(ipEndParts[3]); i++)
            {
                string currentIP = ipStartParts[0] + "." + ipStartParts[1] + "." + ipStartParts[2] + "." + i.ToString();
                string currentMAC = GetMacAddress(currentIP);
                string currentHostname = string.Empty;

                if (!string.IsNullOrEmpty(currentMAC))
                {
                    currentHostname = GetMachineNameFromIPAddress(currentIP);

                    deviceCount++;

                    txbDiscoveryOutput.Text += "Found device at " + currentIP + " (" + currentHostname + ")" + Environment.NewLine;
                    txbDiscoveryOutput.SelectionStart = txbDiscoveryOutput.TextLength;
                    txbDiscoveryOutput.ScrollToCaret();
                }

                if(prbDiscoveryProgress.Value < prbDiscoveryProgress.Maximum)
                    prbDiscoveryProgress.Value++;
            }

            prbDiscoveryProgress.Value = rangeSize;

            btnFinishDiscover.Enabled = true;
            MessageBox.Show("Discovery finished!" + Environment.NewLine + $"Found a total of {deviceCount} devices.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }


        private string GetMachineNameFromIPAddress(string ipAdress)
        {
            string machineName = string.Empty;
            try
            {
                IPHostEntry hostEntry = Dns.GetHostEntry(ipAdress);

                machineName = hostEntry.HostName;
            }
            catch (Exception ex)
            {
                // Machine not found...
            }
            return machineName;
        }

        public string GetMacAddress(string ip)
        {
            var macIpPairs = GetAllMacAddressesAndIppairs();
            int index = macIpPairs.FindIndex(x => x.IpAddress == ip);
            if (index >= 0)
            {
                return macIpPairs[index].MacAddress.ToUpper();
            }
            else
            {
                return null;
            }
        }

        public List<MacIpPair> GetAllMacAddressesAndIppairs()
        {
            List<MacIpPair> mip = new List<MacIpPair>();
            System.Diagnostics.Process pProcess = new System.Diagnostics.Process();
            pProcess.StartInfo.FileName = "arp";
            pProcess.StartInfo.Arguments = "-a ";
            pProcess.StartInfo.UseShellExecute = false;
            pProcess.StartInfo.RedirectStandardOutput = true;
            pProcess.StartInfo.CreateNoWindow = true;
            pProcess.Start();
            string cmdOutput = pProcess.StandardOutput.ReadToEnd();
            string pattern = @"(?<ip>([0-9]{1,3}\.?){4})\s*(?<mac>([a-f0-9]{2}-?){6})";

            foreach (Match m in Regex.Matches(cmdOutput, pattern, RegexOptions.IgnoreCase))
            {
                mip.Add(new MacIpPair()
                {
                    MacAddress = m.Groups["mac"].Value,
                    IpAddress = m.Groups["ip"].Value
                });
            }

            return mip;
        }
        public struct MacIpPair
        {
            public string MacAddress;
            public string IpAddress;
        }

        private void BtnFinishDiscover_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.OK;
            this.Close();
        }
    }
}
