def transform_imports(raw):
    """transform_imports reads a dict containing raw battery readings
    and returns a dict in human readable format

    :param raw: the raw readings
    :type raw: dict
    :return: translated output
    :rtype: dict
    """

    out = {}

    # timestamp
    out['timestamp'] = raw.get('glb_tsp', 0)
    # gateway Hardware ID (mac address)
    out['hardware_mac_id'] = raw.get('gtw_mac_id', 0)
    # pbx Hardware ID (mac address)
    out['device_id'] = raw.get('pbx_mac_id', 0)

    # Command&Control Component

    # Steuerlogik Hardware ID
    out['ctl_hardware_id'] = raw.get('reg_00', 0)
    # Steuerlogik Netz OK
    out['ctl_mains_ok'] = raw.get('reg_12', 0)
    # Steuerlogik Transfer OK
    out['ctl_transfer_ok'] = raw.get('reg_13', 0)
    # Steuerlogik Netz abgeworfen
    out['ctl_mains_thrown'] = raw.get('reg_14', 0)
    # Steuerlogik Relais kontrolle (Status 1 wenn OK und Kontakte nicht kleben geblieben)
    out['ctl_relais_ok'] = raw.get('reg_15', 0)
    # Steuerlogik Batt haltespannung Batteriehaltespannung. Liefert Anzahl Minuten bis auf Erhaltungsladung
    out['ctl_voltage_battery_hold'] = raw.get('reg_16', 0)
    # Steuerlogik U batt mess Reale Batteriespannung in mV
    out['ctl_voltage_battery_measured'] = raw.get('reg_1A', 0)
    # Steuerlogik U batt schnell, gemessene Schnelle Batteriespannung
    out['ctl_voltage_battery_fastmeasured'] = raw.get('reg_29', 0)
    # Steuerlogik I lade Ladestrom der in die Batterie fliesst in mA
    out['ctl_power_charge'] = raw.get('reg_18', 0)
    # Steuerlogik I entlade Entladestrom der in die Batterie fliesst in mA. Zur Berechnung eines einzelnen Werts: Lade - Entlade rechnen.
    out['ctl_power_discharge'] = raw.get('reg_19', 0)
    # Steuerlogik I lade schnell, in mV
    out['ctl_power_fastcharge'] = raw.get('reg_27', 0)
    # Steuerlogik I entlade schnell, in mV
    out['ctl_power_fastdischarge'] = raw.get('reg_28', 0)

    # Steuerlogik Temp Akku, Batterietemperatur in Zehntelgradcelsius (1°C/10), 'als Offset von -100 wegen Minustemperaturen'
    try:
        out['ctl_temperature_battery'] = (int(raw.get('reg_1C', 0)) - 100) / 10
    except Exception:
        out['ctl_temperature_battery'] = 0

    # Steuerlogik Temp Print Umgebungstemperatur Elektronik in Zehntelgradcelsius (1°C/10), 'als Offset von -100 wegen Minustemperaturen'
    try:
        out['ctl_temperature_print'] = (int(raw.get('reg_1D', 0)) - 100) / 10
    except Exception:
        out['ctl_temperature_print'] = 0

    # Steuerlogik Statusbits, statusbits.txt
    out['ctl_state_bits'] = raw.get('reg_1E', 0)
    # Steuerlogik Ladestand in 1%/10, realer technischer Ladestand von 0%-100%
    try:
        out['ctl_charge_percentage'] = int(raw.get('reg_22', 0)) / 10
    except Exception:
        out['ctl_charge_percentage'] = 0

    # Steuerlogik LAdestand LED, 1%/10 Anzeigestand der LED
    try:
        out['ctl_charge_led'] = int(raw.get('reg_23', 0)) / 10
    except Exception:
        out['ctl_charge_led'] = 0

    # MPPT (Maximum Power Point Tracking of PV Module)

    # MPPT Hardware ID
    out['mpp_hardware_id'] = raw.get('reg_40', 0)
    # MPPT SW Version
    out['mpp_software_rev'] = raw.get('reg_41', 0)
    # MPPT P out in 1W/100, gerechnete Leistung des Solarmodules
    out['mpp_wattage_out'] = raw.get('reg_51', 0)
    # MPPT Statusbits, statusbits.txt
    out['mpp_state_bits'] = raw.get('reg_52', 0)
    # MPPT Upanel in mV Reale Spannung am Solarmodul
    out['mpp_voltage_solarpanel'] = raw.get('reg_4F', 0)

    # MPPT Temperatur in 1°C/10 Temperatur der Leistungselektronik des MPPT
    try:
        out['mpp_temperature'] = int(raw.get('reg_50', 0)) / 10
    except Exception:
        out['mpp_temperature'] = 0

    # Inverter

    # Inverter Hardware ID
    out['inv_hardware_id'] = raw.get('reg_80', 0)
    # Inverter SW Version
    out['inv_software_rev'] = raw.get('reg_01', 0)
    # Inverter I effektiv 1A/10.000 Mittelwert des WRAusgangsstroms (Effektivwert). Zur Berechnung der Leistung des WR [Wechselrichters], kann dieser Wert mit 225V multipliziert werden, was einen Näherungswert der Leistung ergibt.
    try:
        out['inv_power_effective'] = int(raw.get('reg_8C', 0)) / 10
    except Exception:
        out['inv_power_effective'] = 0

    # Inverter Temperator in 1°C/10 Temperatur der WR Leistungselektronik. Bei 75° wird abgestellt.
    try:
        out['inv_temperature'] = int(raw.get('reg_8D', 0)) / 10
    except Exception:
        out['inv_temperature'] = 0

    # Inverter Frequenz (Wr f (16bit)) in 1/(Hz/2000000)
    try:
        out['inv_inverter_frequency'] = int(raw.get('reg_8F', 0)) / 2000000
    except Exception:
        out['inv_inverter_frequency'] = 0

    # Inverter Statusbits, statusbits.txt
    out['inv_state_bits'] = raw.get('reg_93', 0)

    # Charger

    # Netz Laderegler I soll. Solladestrom im Normalfall auf Maximalleistung (5A)
    out['chg_power_expected'] = raw.get('reg_C9', 0)
    # Netz Laderegler U soll. Solladespannung.
    out['chg_voltage_expected'] = raw.get('reg_CA', 0)

    return out
