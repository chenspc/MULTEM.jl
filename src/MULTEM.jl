module MULTEM

using Configurations: @option, from_dict, to_dict, to_toml

import Configurations: toml_convert
import FieldMetadata: @description, description
import Base: convert

export from_dict, to_dict, to_toml
export MULTEMInput 
export System, Theory, Simulation, Specimen, Instrument 
# export ElectronPhononInteraction, ElectronSpecimenInteraction, IncidentWave, Illumination, Aberrations, DefocusSpreadFunction, ZeroDefocusReference, ObjectiveLens, SourceSpreadFunction, CondenserLens, ScanningArea, Detector, Rotation, Thickness, Amorphous, Crystal, XYSampling, Atom, OutputRegion, HCI, EELS, PET, EFTEM
# export Precision, Device, ElectronSpecimenInteractionModel, PotentialType, OperationMode, PhononModel, ThicknessType, PotentialSlicing, SimulationType, IncidentWaveType, IlluminationModel, IlluminationIncoherenceMode, ScanningType, ZeroDefocusType, DetectorType

@enum Precision begin
    eP_Float = 1
    eP_Double = 2
end

@enum Device begin
    eD_CPU = 1
    eD_GPU = 2
end

@enum ElectronSpecimenInteractionModel begin
    eESIM_Multislice = 1
    eESIM_Phase_Object = 2
    eESIM_Weak_Phase_Object = 3
end

@enum PotentialType begin
    ePT_Doyle_0_4 = 1
    ePT_Peng_0_4 = 2
    ePT_Peng_0_12 = 3
    ePT_Kirkland_0_12 = 4
    ePT_Weickenmeier_0_12 = 5
    ePT_Lobato_0_12 = 6
end

@enum OperationMode begin
    eOM_Normal = 1
    eOM_Advanced = 2
end

@enum PhononModel begin
    ePM_Still_Atom = 1
    ePM_Absorptive = 2
    ePM_Frozen_Phonon = 3
end

@enum ThicknessType begin
    eTT_Whole_Spec = 1
    eTT_Through_Thick = 2
    eTT_Through_Slices = 3
end

@enum PotentialSlicing begin
    ePS_Planes = 1
    ePS_dz_Proj = 2
    ePS_dz_Sub = 3
    ePS_Auto = 4
end

@enum SimulationType begin
    eST_STEM = 11
    eST_ISTEM = 12
    eST_CBED = 21
    eST_CBEI = 22

    eST_ED = 31
    eST_HRTEM = 32
    eST_PED = 41
    eST_HCTEM = 42

    eST_EWFS = 51
    eST_EWRS = 52
    eST_EELS = 61
    eST_EFTEM = 62

    eST_ProbeFS = 71
    eST_ProbeRS = 72
    eST_PPFS = 81
    eST_PPRS = 82

    eST_TFFS = 91
    eST_TFRS = 92
end

@enum IncidentWaveType begin
    eIWT_Plane_Wave = 1
    eIWT_Convergent_Wave = 2
    eIWT_User_Define_Wave = 3
    eIWT_Auto_Wave = 4
end

@enum IlluminationModel begin
    eIM_Coherente_Mode = 1
    eIM_Partial_Coherente_Mode = 2
    eIM_Transmission_Cross_Coefficient = 3
    eIM_Numerical_Integration = 4
end

@enum IlluminationIncoherenceMode begin
    eIIM_Temporal_And_Spatial_Incoherence = 1
    eIIM_Temporal_Incoherence = 2
    eIIM_Spatial_Incoherence = 3
end

@enum ScanningType begin
    eST_Line = 1
    eST_Area = 2
end


@enum ZeroDefocusType begin
    eZDT_First = 1
    eZDT_Middle = 2
    eZDT_Last = 3
    eZDT_User_Define = 4
end


@enum DetectorType begin
    eDT_Circular = 1
    eDT_Radial = 2
    eDT_Matrix = 3
end


@enum CenterType begin
    eCT_Geometric = 1
    eCT_User = 2
end

MULTEMEnum = Union{Precision, Device, ElectronSpecimenInteractionModel, PotentialType, OperationMode, PhononModel, ThicknessType, PotentialSlicing, SimulationType, IncidentWaveType, IlluminationModel, IlluminationIncoherenceMode, ScanningType, ZeroDefocusType, DetectorType}
# toml_convert(::Type, x::T) where T<:MULTEMEnum = string(x)
toml_convert(::Type, x::T) where T<:MULTEMEnum = Int(x)
convert(::Type{T}, x::Int) where T<:MULTEMEnum = T(x)

@description @option struct ElectronPhononInteraction
    model::PhononModel = ePM_Still_Atom | ""
    coherence_contribution::Bool = false | ""
    single_phonon_configuration::Bool = false | ""
    number_of_configuration::Int =
        1 |
        "???true: specific phonon configuration, false: number of frozen phonon configurations"
    dimensions::Int = 110 | "phonon dimensions (xyz)"
    seed::Int = 300183 | "Random seed(frozen phonon)"
end

@option struct ElectronSpecimenInteraction
    reverse_multislice::Bool = false
    model::ElectronSpecimenInteractionModel = eESIM_Multislice
    memory_size::Int = 0
    operation_mode::OperationMode = eOM_Normal
    potential_type::PotentialType = ePT_Lobato_0_12
end

"EM Theory"
@option struct Theory
    electron_phonon_interaction::ElectronPhononInteraction = ElectronPhononInteraction()
    electron_specimen_interaction::ElectronSpecimenInteraction =
        ElectronSpecimenInteraction()
end

@description @option struct IncidentWave
    acceleration_voltage::Real = 300.0 | "Acceleration Voltage (keV)"
    theta::Real = 0.0 | "Polar angle (°)"
    phi::Real = 0.0 | "Azimuthal angle (°)"
    type::IncidentWaveType = eIWT_Auto_Wave | ""
    psi::Real = 0.0 | ""
    x::Real = 0.0 | ""
    y::Real = 0.0 | ""
end

@option struct Illumination
    model::IlluminationModel = eIM_Transmission_Cross_Coefficient
    incoherence_mode::IlluminationIncoherenceMode = eIIM_Temporal_And_Spatial_Incoherence
end

@option struct Aberrations
    "defocus"
    c_10::Real = 14.0312
    c_12::Real = 0.0
    phi_12::Real = 0.0

    c_21::Real = 0.0
    phi_21::Real = 0.0
    c_23::Real = 0.0
    phi_23::Real = 0.0

    c_30::Real = 0.001
    c_32::Real = 0.0
    phi_32::Real = 0.0
    c_34::Real = 0.0
    phi_34::Real = 0.0

    c_41::Real = 0.0
    phi_41::Real = 0.0
    c_43::Real = 0.0
    phi_43::Real = 0.0
    c_45::Real = 0.0
    phi_45::Real = 0.0

    c_50::Real = 0.0
    c_52::Real = 0.0
    phi_52::Real = 0.0
    c_54::Real = 0.0
    phi_54::Real = 0.0
    c_56::Real = 0.0
    phi_56::Real = 0.0
    
    inner_aperture_angle::Real = 0.0
    outer_aperture_angle::Real = 21.0
    
end

@option struct ObjectiveLensDefocusSpreadFunction
    sigma::Real = 32.0
    integration_npoints::Int = 10
end

@option struct CondenserLensDefocusSpreadFunction
    # `a` and `beta` only for condenser lens???
    a::Real = 1.0
    beta::Real = 1.0

    sigma::Real = 32.0
    integration_npoints::Int = 10
end

@option struct SourceSpreadFunction
    a::Real = 1.0
    sigma::Real = 0.072
    beta::Real = 1.0
    radial_integration_npoints::Int = 4
    azimuthal_integration_npoints::Int = 4
end

@option struct ZeroDefocusReference
    type::ZeroDefocusType = eZDT_First
    plane::Real = 0.0
end

@option struct ObjectiveLens
    vortex_momentum::Real = 0.0
    aberrations::Aberrations = Aberrations()
    defocus_spread_function::ObjectiveLensDefocusSpreadFunction = ObjectiveLensDefocusSpreadFunction()
    zero_defocus_reference::ZeroDefocusReference = ZeroDefocusReference()
end


@option struct CondenserLens
    vortex_momentum::Real = 0.0
    aberrations::Aberrations = Aberrations()
    defocus_spread_function::CondenserLensDefocusSpreadFunction = CondenserLensDefocusSpreadFunction()
    source_spread_function::SourceSpreadFunction = SourceSpreadFunction()
    zero_defocus_reference::ZeroDefocusReference = ZeroDefocusReference()
end

@option struct ScanningArea
    type::ScanningType = eST_Area
    periodic_boundary_conditions::Bool = false
    square_pixel::Bool = true
    sampling_npoints::Int = 10
    x0::Real = 0.0
    y0::Real = 0.0
    xe::Real = 4.078
    ye::Real = 4.078
end


@option struct Detector
    type::DetectorType = eDT_Circular
    inner_angle::Real = 60.0
    outer_angle::Real = 180.0
    radial_sensitivity::Real = 0.0
    matrix_sensitivity::Real = 0.0
end

"Instrument"
@option struct Instrument
    incident_wave::IncidentWave = IncidentWave()
    illumination::Illumination = Illumination()
    objective_lens::ObjectiveLens = ObjectiveLens()
    scanning_area::ScanningArea = ScanningArea()
    condenser_lens::CondenserLens = CondenserLens()
    detector::Detector = Detector()
end


@option struct Rotation
    theta::Real = 0.0
    center_type::Real = 1
    center_p::AbstractVector{Real} = [0.0, 0.0, 0.0]
    u0::AbstractVector{Real} = [0.0, 0.0, 1.0]
end

@option struct Thickness
    thick_array::AbstractVector{Real} = [0.0]
    type::ThicknessType = eTT_Whole_Spec
end

@option struct Amorphous
    z0::Real = 0.0
    ze::Real = 0.0
    dz::Real = 2.0
end

@option struct Crystal
    na::Real = 1.0
    nb::Real = 1.0
    nc::Real = 1.0
    a::Real = 0.0
    b::Real = 0.0
    c::Real = 0.0
    x0::Real = 0.0
    y0::Real = 0.0
end

@option struct XYSampling
    nx::Int = 256
    ny::Int = 256
    band_width_limit::Real = 0.0
end

@option struct Atom
    Z::Int = 0
    x::Real = 0.0
    y::Real = 0.0
    z::Real = 0.0
    rms::Real = 0.085
    occupancy::Real = 1.0
    area::Int = 0
end

"Specimen"
@option struct Specimen
    rotation::Rotation = Rotation()
    thickness::Thickness = Thickness()
    amorphous::Amorphous = Amorphous()
    lx::Real = 10.0
    ly::Real = 10.0
    lz::Real = 10.0
    dz::Real = 0.25
    crystal::Crystal = Crystal()
    xy_sampling::XYSampling = XYSampling()
    potential_slicing::PotentialSlicing = ePS_Planes
    atoms::AbstractVector{Atom} = Vector{Atom}[]
end

@option struct OutputRegion
    ix_0::Real = 0.0
    iy_0::Real = 0.0
    ix_e::Real = 0.0
    iy_e::Real = 0.0
end

@option struct HCI
    theta::Real = 3.0
    nrotations::Real = 360.0
end

@option struct EELS
    atomic_number::Real = 79
    collection_angle::Real = 100.0
    m_selection::Real = 3.0
    E_loss::Real = 80.0
    channelling_type::Real = 1
end

@option struct PET
    theta::Real = 3.0
    nrotations::Real = 360.0
end

@option struct EFTEM
    atomic_number::Real = 79
    collection_angle::Real = 100.0
    m_selection::Real = 3.0
    E_loss::Real = 80.0
    channelling_type::Real = 1
end


"Simulation"
@option struct Simulation
    output_region::OutputRegion = OutputRegion()
    hci::HCI = HCI()
    eels::EELS = EELS()
    pet::PET = PET()
    eftem::EFTEM = EFTEM()
    type::SimulationType = eST_EWRS
end


"System"
@option struct System
    cpu_nthreads::Int = 1
    cpu_ncores::Int = 1
    device::Device = eD_GPU
    gpu_device::Int = 0
    precision::Precision = eP_Float
end

"MULTEM Input"
@option struct MULTEMInput
    "system"
    system::System = System()
    theory::Theory = Theory()
    simulation::Simulation = Simulation()
    specimen::Specimen = Specimen()
    instrument::Instrument = Instrument()
end

end

# @enum CondenserLensZeroDefocusReferenceType begin
#     eCLZDT_First = 1
#     eCLZDT_User_Define = 4
# end

# @enum ObjectiveLensZeroDefocusReferenceType begin
#     eOLZDT_First = 1
#     eOLZDT_Middle = 2
#     eOLZDT_Last = 3
#     eOLZDT_User_Define = 4
# end